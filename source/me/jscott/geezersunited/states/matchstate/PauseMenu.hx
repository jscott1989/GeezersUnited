package me.jscott.geezersunited.states.matchstate;

import flixel.FlxG;
import me.jscott.geezersunited.states.menustate.MenuState;
import me.jscott.ui.Menu;

class PauseMenu extends Menu {

    var matchState:MatchState;

    public function new(matchState:MatchState) {
        super(matchState, matchState);
        this.matchState = matchState;
    }

    override public function create():Void {
        _xml_id = "pause";
        super.create();
    }

    override public function AButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
        if (sender.name == "continue") {
            close();
        } else if (sender.name == "tactics") {
            close();
            matchState.openTactics();
        } else if (sender.name == "quit") {
            FlxG.switchState(new MenuState());
        }
    }
}