package me.jscott.geezersunited.states.matchstate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIText;
import flixel.util.FlxColor;
import me.jscott.geezersunited.sides.Side;
import me.jscott.ui.Menu;
import me.jscott.ui.controllers.Controller;

class TacticsMenu extends Menu {
    var side:Side;
    var continueCallback:Formation->Void;
    public var continued = false;

    var formationButton:FlxUIButton;
    var currentFormation:Int;

    var playerButtons = new Array<FlxUIButton>();
    var playerPositions = new Array<FlxUIText>();

    var selectedPosition:Int;

    public function new(splitScreenMenuHost:SplitScreenMenuHost, side:Side, continueCallback:Formation->Void) {
        super(splitScreenMenuHost, splitScreenMenuHost);
        this.side = side;
        this.continueCallback = continueCallback;

        if (this.side.getControllers().length == 0) {
            continued = true;
            continueCallback(side.formation);
        }

        currentFormation = Formation.FORMATIONS.indexOf(side.formation);
    }

    function refreshView() {
        formationButton.label.text = Formation.FORMATIONS[currentFormation].name;
        for (i in 0...5) {
            playerPositions[i].text = Formation.FORMATIONS[currentFormation].roles[i];
        }

        for (i in 0...10) {
            playerButtons[i].label.text = Std.string(side.positions[i].player.getID()) + " " + side.positions[i].player.getName();
        }
    }

    override public function create():Void {
        _xml_id = "tactics";
        super.create();
        formationButton = cast _ui.getAsset("formation");

        for (i in 1...11) {
            playerButtons.push(cast _ui.getAsset("player" + Std.string(i)));
            playerPositions.push(cast _ui.getAsset("player" + Std.string(i) + "_position"));
        }

        if (this.side.getControllers().length == 0) {
            menuHost.removeFromUI(frt_cursor);
        }

        refreshView();
    }

    public override function AButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        if (this.side.getControllers().length == 0) {
            return;
        }
        if (sender.name == "formation") {
            currentFormation += 1;
            if (currentFormation >= Formation.FORMATIONS.length) {
                currentFormation = 0;
            }
            refreshView();
        } else if (sender.name == "continue") {
            continued = true;
            continueCallback(Formation.FORMATIONS[currentFormation]);
        } else {
            var p:Int = params[0];
            if (selectedPosition == null) {
                // Select this one
                selectedPosition = p;
                sender.x += 10;
            } else if (selectedPosition == p) {
                // Deselect
                selectedPosition = null;
                sender.x -= 10;
            } else {
                // Swap the players
                side.swapPlayers(selectedPosition, p);
                playerButtons[selectedPosition].x -= 10;
                selectedPosition = null;
                refreshView();
            }
        }
    }

    public override function update(elapsed:Float) {
        if (!continued && this.side.getControllers().length > 0) {
            super.update(elapsed);
        }
    }
}