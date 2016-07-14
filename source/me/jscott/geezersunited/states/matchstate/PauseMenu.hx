package me.jscott.geezersunited.states.matchstate;

import flixel.FlxG;
import me.jscott.ui.Menu;
import me.jscott.geezersunited.states.menustate.MenuState;

class PauseMenu extends Menu {

    override public function create():Void {
        _xml_id = "pause";
        super.create();
    }

    override public function AButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
        if (sender.name == "continue") {
            close();
        } else if (sender.name == "tactics") {
            // When we open tactics we need to split the screen
        } else if (sender.name == "quit") {
            FlxG.switchState(new MenuState());
        }
    }
}