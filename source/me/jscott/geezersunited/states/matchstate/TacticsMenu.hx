package me.jscott.geezersunited.states.matchstate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIText;
import flixel.util.FlxColor;
import me.jscott.geezersunited.sides.Side;
import me.jscott.ui.Menu;
import me.jscott.ui.controllers.Controller;

class TacticsMenu extends Menu {
    var side:Side;
    var continueCallback:Void->Void;
    public var continued = false;

    public function new(splitScreenMenuHost:SplitScreenMenuHost, side:Side, continueCallback:Void->Void) {
        super(splitScreenMenuHost, splitScreenMenuHost);
        this.side = side;
        this.continueCallback = continueCallback;

        if (this.side.getControllers().length == 0) {
            continued = true;
            continueCallback();
        }
    }

    override public function create():Void {
        _xml_id = "tactics";
        super.create();
    }

    public override function AButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        if (sender.name == "continue") {
            continued = true;
            continueCallback();
        }
    }

    public override function update(elapsed:Float) {
        if (!continued) {
            super.update(elapsed);
        }
    }
}