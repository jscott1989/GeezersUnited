package me.jscott.geezersunited.sides;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import me.jscott.Utils;
import me.jscott.ui.controllers.Controller;
import me.jscott.geezersunited.states.matchstate.MatchState;
import me.jscott.geezersunited.states.matchstate.Player;

/**
 * A HumanSide can be controlled by a controller.
 *
 * TODO: Allow more than one controller per side?
 */
class HumanSide extends Side {
    var controller: Controller;
    var selectedPlayer = 0;

    // This records players we shouldn't select (because we're tabbing through players)
    var ignoredSelections = new Array<Player>();

    // TODO: if we allow more than one controller per side - have multiple colours too
    static var colors = [FlxColor.PINK, FlxColor.RED];

    public function new(side:Int, matchState: MatchState, controllers: Array<Controller>) {
        this.controller = controllers[0];
        super(side, matchState);
    }

    override public function resetState() {
        ignoredSelections = new Array<Player>();
        selectClosestToBall();
    }

    function selectClosestToBall(ignore:Array<Player> = null) {
        var mostForwardPlayerI = 0;
        var mostForwardDistance = 9999999999999;
        var ballPosition = new FlxPoint(matchState.ball.body.position.x, matchState.ball.body.position.y);

        for (p in 0...5) {
            var player = matchState.players[side][p];
            var playerPosition = new FlxPoint(player.body.position.x, player.body.position.y);
            var x = playerPosition.distanceTo(ballPosition);
            if (x < mostForwardDistance && (ignore == null || ignore.indexOf(player) == -1)) {
                mostForwardPlayerI = p;
                mostForwardDistance = x;
            }
        }

        matchState.players[side][selectedPlayer].setHighlighted(null);
        selectedPlayer = mostForwardPlayerI;
        matchState.players[side][selectedPlayer].setHighlighted(colors[side]);
    }

    function changeSelection() {
        // Find the next closest player 

        ignoredSelections.push(matchState.players[side][selectedPlayer]);
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
                matchState.players[side][selectedPlayer].turnTowards(targetAngle, elapsed);
            } else {
                matchState.players[side][selectedPlayer].moveTowards(targetAngle, elapsed);
            }
        }

        if (this.controller.xJustPressed()) {
            if (ignoredSelections.length > 0) {
                ignoredSelections = new Array<Player>();
            }
            matchState.players[side][selectedPlayer].kick(elapsed);
        }
    }

    public override function update(elapsed:Float) {
        controller.update(elapsed);
        moveControlled(elapsed);
        // Next control each player given their starting position, maximum range and individual traits
        for (p in 0...5) {
            if (selectedPlayer != p) {
                controlPlayer(p, elapsed);
            }
        }
    }
}