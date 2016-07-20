package me.jscott.geezersunited.sides;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import me.jscott.Configuration;
import me.jscott.Utils;
import me.jscott.geezersunited.Formation;
import me.jscott.geezersunited.data.Data;
import me.jscott.geezersunited.data.TeamDefinition;
import me.jscott.geezersunited.states.matchstate.MatchState;
import me.jscott.geezersunited.states.matchstate.Player;
import me.jscott.ui.controllers.Controller;

/**
 */
class Side {
    var controller: Controller;
    var selectedPlayer = 0;

    var side:Int;
    var matchState:MatchState;

    public var formation:Formation;
    public var team:TeamDefinition;

    // This records players we shouldn't select (because we're tabbing through players)
    var ignoredSelections = new Array<Player>();

    // TODO: if we allow more than one controller per side - have multiple colours too
    static var colors = [FlxColor.BLUE, FlxColor.RED];

    var players:Array<Player>;
    public var positions:Map<Int, Player>;
    var positionsReversed:Map<Player, Int>;

    public function getPlayers() {
        if (players == null) {
            players = new Array<Player>();
            positions = new Map<Int, Player>();
            positionsReversed = new Map<Player, Int>();
            var p = team.getPlayers();
            for (i in 0...10) {
                var player = new Player(matchState, p[i], team.getColor());
                players.push(player);
                positions.set(i, player);
                positionsReversed.set(player, i);
            }
            setupPlayers(true);
        }

        return players;
    }

    public function new(side:Int, matchState: MatchState, team:TeamDefinition, controllers: Array<Controller>=null) {
        if (controllers != null) {
            this.controller = controllers[0];
        }
        this.side = side;
        this.matchState = matchState;
        this.team = team;
        this.formation = team.getFormation();
    }

    public function setControllers(controllers:Array<Controller>=null) {
        if (controllers != null) {
            this.controller = controllers[0];
        } else {
            this.controller = null;
        }
        resetState();
    }

    public function resetState() {
        ignoredSelections = new Array<Player>();
        if (this.controller != null) {
            selectClosestToBall();
        }
    }

    public function swapPlayers(index1:Int, index2:Int) {
        var player1 = positions[index1];
        var player2 = positions[index2];

        positions[index1] = player2;
        positions[index2] = player1;

        positionsReversed[player1] = index2;
        positionsReversed[player2] = index1;
    }

    function selectClosestToBall(ignore:Array<Player> = null) {
        var mostForwardPlayerI = 0;
        var mostForwardDistance = 9999999999999;
        var ballPosition = new FlxPoint(matchState.ball.body.position.x, matchState.ball.body.position.y);

        for (p in 0...5) {
            var player = positions[p];
            var playerPosition = new FlxPoint(player.body.position.x, player.body.position.y);
            var x = playerPosition.distanceTo(ballPosition);
            if (x < mostForwardDistance && (ignore == null || ignore.indexOf(player) == -1)) {
                mostForwardPlayerI = p;
                mostForwardDistance = x;
            }
        }

        positions[selectedPlayer].setHighlighted(null);
        selectedPlayer = mostForwardPlayerI;
        positions[selectedPlayer].setHighlighted(colors[side]);
    }

    function changeSelection() {
        // Find the next closest player 

        ignoredSelections.push(positions[selectedPlayer]);
        if (ignoredSelections.length == 5) {
            ignoredSelections = new Array<Player>();
        }
        selectClosestToBall(ignoredSelections);
    }

    function moveControlled(elapsed:Float) {
        if (this.controller.lBumperJustPressed()) {
            changeSelection();
        }

        var targetAngle = this.controller.getAnalogAngle();

        if (targetAngle != null) {
            if (ignoredSelections.length > 0) {
                ignoredSelections = new Array<Player>();
            }
            var velocity = this.controller.getAnalogVelocity();
            // TODO: allow slower/faster movement using this velocity
            if (velocity < 0.5) {
                positions[selectedPlayer].turnTowards(targetAngle, elapsed);
            } else {
                positions[selectedPlayer].moveTowards(targetAngle, elapsed);
            }
        }

        if (this.controller.xJustPressed()) {
            if (ignoredSelections.length > 0) {
                ignoredSelections = new Array<Player>();
            }
            positions[selectedPlayer].kick(elapsed);
        }
    }

    public function getRole(player:Player) {
        return formation.roles[positionsReversed[player]];
    }

    public function setupPlayers(moveInstant=false) {
        var pitch = matchState.pitch;
        var centre = pitch.y + pitch.height / 2;
        var startPos = pitch.x;
        if (side == 1) {
            startPos = pitch.x + pitch.width;
        }

        for (i in 0...5) {
            var xOffset = pitch.width * formation.points[i].x;
            var yOffset = pitch.height * formation.points[i].y;

            var x = startPos + xOffset;
            if (side == 1) {
                x = startPos - xOffset;
            }
            var y = centre + yOffset;

            positions[i].formationPosition = new FlxPoint(x, y);

            if (moveInstant) {
                positions[i].body.position.x = x;
                positions[i].body.position.y = y;

                if (side == 1) {
                    positions[i].body.rotation = Utils.degToRad(270);
                } else {
                    positions[i].body.rotation = Utils.degToRad(90);
                }
            } else {
                // If we have a player who is moving on to the pitch - we need to jump them to the edge
                if (positions[i].body.position.x < pitch.x && positions[i].body.position.y < pitch.y) {
                    positions[i].body.position.x = pitch.x + pitch.width / 2;
                    positions[i].body.position.y = pitch.y + 1;

                    positions[i].body.rotation = Utils.degToRad(180);
                }
            }
        }

        for (i in 5...10) {
            if (moveInstant) {
                positions[i].formationPosition = new FlxPoint(-1000, -1000);
                positions[i].body.position.x = -1000;
                positions[i].body.position.y = -1000;
            }
        }
    }

    function controlPlayer(playerI:Int, elapsed:Float) {
        // Move to ensure that we're 50% between the ball's position and our "natural" position
        var player = positions[playerI];
        var ballPosition = new FlxPoint(matchState.ball.body.position.x, matchState.ball.body.position.y);

        if (getRole(player) == Player.GK) {
            var targetPosition = new FlxPoint(player.formationPosition.x, player.formationPosition.y);
            targetPosition.y = ballPosition.y;
            var targetAngle = Utils.normaliseAngle(targetPosition.angleBetween(ballPosition));
            player.moveToPoint(targetPosition, targetAngle, elapsed);
        } else {
            var targetPosition = new FlxPoint(player.formationPosition.x, player.formationPosition.y);
            var targetAngle = Utils.normaliseAngle(targetPosition.angleBetween(ballPosition));
            player.moveToPoint(targetPosition, targetAngle, elapsed);
        }

        // targetPosition.x = (targetPosition.x + ballPosition.x) / 2;
        // targetPosition.y = (targetPosition.y + ballPosition.y) / 2;
    }

    public function update(elapsed:Float) {
        if (controller == null) {
            for (p in 0...5) {
                controlPlayer(p, elapsed);
            }
        } else {
            controller.update(elapsed);

            moveControlled(elapsed);
            // Next control each player given their starting position, maximum range and individual traits
            for (p in 0...5) {
                if (selectedPlayer != p) {
                    controlPlayer(p, elapsed);
                }
            }

            if (controller.startJustPressed()) {
                matchState.pause();
            }
        }
        var pitch = matchState.pitch;
        for (p in 5...10) {
            if (positions[p].body.position.x > pitch.x && positions[p].body.position.y > pitch.y) {
                if (positions[p].body.position.x > 483 && positions[p].body.position.x < 512 &&
                    positions[p].body.position.y < 240) {
                    // We're done - jump off
                    positions[p].body.position.x = -1000;
                    positions[p].body.position.y = -1000;
                } else {
                    // This player needs to leave the pitch
                    var targetPosition = new FlxPoint(pitch.x + pitch.width / 2, pitch.y);
                    positions[p].moveToPoint(targetPosition, 0, elapsed);
                }
            }
        }
    }

    public function getControllers() {
        if (controller == null) {
            return [];
        }
        return [controller];
    }
}