package me.jscott.geezersunited.sides;

import me.jscott.geezersunited.controllers.Controller;
import me.jscott.geezersunited.states.matchstate.MatchState;
import flixel.util.FlxColor;

/**
 * A HumanSide can be controlled by a controller.
 *
 * TODO: Allow more than one controller per side?
 */
class HumanSide extends Side {
    var controller: Controller;
    var selectedPlayer = 0;

    // TODO: if we allow more than one controller per side - have multiple colours too
    static var colors = [FlxColor.BLUE, FlxColor.RED];

    public function new(side:Int, matchState: MatchState, controller: Controller) {
        this.controller = controller;
        super(side, matchState);
    }

    function prevSelection() {
        matchState.players[side][selectedPlayer].setHighlighted(null);
        selectedPlayer -= 1;
        if (selectedPlayer < 0) {
            selectedPlayer = 4;
        }
        matchState.players[side][selectedPlayer].setHighlighted(colors[side]);
    }

    function nextSelection() {
        matchState.players[side][selectedPlayer].setHighlighted(null);
        selectedPlayer += 1;
        if (selectedPlayer > 4) {
            selectedPlayer = 0;
        }
        matchState.players[side][selectedPlayer].setHighlighted(colors[side]);
    }

    public override function update(elapsed:Float) {
        if (this.controller.RJustPressed()) {
            nextSelection();
        } else if (this.controller.LJustPressed()) {
            prevSelection();
        }

        var targetAngle = 0;
        var move = false;

        if (this.controller.upPressed()) {
            if (this.controller.leftPressed()) {
                targetAngle = 315;
            } else if (this.controller.rightPressed()) {
                targetAngle = 45;
            } else {
                targetAngle = 0;
            }
            move = true;
        } else if (this.controller.downPressed()) {
            if (this.controller.leftPressed()) {
                targetAngle = 225;
            } else if (this.controller.rightPressed()) {
                targetAngle = 135;
            } else {
                targetAngle = 180;
            }
            move = true;
        } else if (this.controller.leftPressed()) {
            targetAngle = 270;
            move = true;
        } else if (this.controller.rightPressed()) {
            targetAngle = 90;
            move = true;
        }

        if (move) {
            // selectedPlayer
            var currentAngle = Utils.radToDeg(matchState.players[side][selectedPlayer].body.rotation);

            if (Math.abs(currentAngle - targetAngle) < Reg.ROTATION_SPEED) {
                // TODO: Move...
                matchState.players[side][selectedPlayer].body.position.y -=  Math.cos(matchState.players[side][selectedPlayer].body.rotation) * Reg.TRAVEL_SPEED;
                matchState.players[side][selectedPlayer].body.position.x += Math.sin(matchState.players[side][selectedPlayer].body.rotation) * Reg.TRAVEL_SPEED;
            } else {
                // We need to figure out if it's quicker to go down or up
                var differenceUp = targetAngle - currentAngle;
                var differenceDown = currentAngle + 360 - targetAngle;
                if (targetAngle < currentAngle) {
                    differenceUp = targetAngle + 360 - currentAngle;
                    differenceDown = currentAngle - targetAngle;
                }

                var newAngle = currentAngle + Reg.ROTATION_SPEED;
                if (differenceUp > differenceDown) {
                    newAngle = currentAngle - Reg.ROTATION_SPEED;
                }

                if (newAngle >= 360) {
                    newAngle -= 360;
                }

                if (newAngle < 0) {
                    newAngle = 360 + newAngle;
                }

                matchState.players[side][selectedPlayer].body.rotation = Utils.degToRad(newAngle);

            }
        }
    }
}