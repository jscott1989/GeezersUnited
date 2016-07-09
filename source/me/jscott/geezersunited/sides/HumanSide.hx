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
    }
}