package me.jscott.geezersunited.states.leaguestate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxPoint;
import me.jscott.ui.Menu;
import me.jscott.ui.MenuHost;
import me.jscott.ui.controllers.Controller;
import me.jscott.ui.controllers.GamepadController;
import me.jscott.ui.controllers.KeyboardController;
import flixel.input.gamepad.FlxGamepad;

class LeagueState extends FlxUIState implements MenuHost {

    public var controllers:Array<Controller>;
    public var loadedGamepads = new Array<FlxGamepad>();

    var menu:Menu;

    public function new(controllers:Array<Controller>, loadedGamepads:Array<FlxGamepad>) {
        super();

        this.controllers = controllers;
        this.loadedGamepads = loadedGamepads;
    }

    override public function create():Void {
        super.create();
        // TODO: In future we need a side select/etc. For now we'll just initialise the teams

        openMenu(new LeagueMenu(this));
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        // Check for new gamepads
        for (gamepad in FlxG.gamepads.getActiveGamepads()) {
            if (loadedGamepads.indexOf(gamepad) == -1) {
                controllers.push(new GamepadController(gamepad));
                loadedGamepads.push(gamepad);
            }
        }

        if (menu != null) {
            menu.update(elapsed);
        }
    }

    public function openMenu(menu:Menu) {
        menu.create();
        this.menu = menu;
    }

    public function closeMenu() {
        this.menu = null;
    }

    public function getControllers():Array<Controller> {
        return controllers;
    }

    public function addToUI(i:FlxSprite) {
        add(i);
    }

    public function removeFromUI(i:FlxSprite) {
        remove(i);
    }

    public function getCameraOffset() {
        return new FlxPoint(0, 0);
    }

    public function isSplitScreen() {
        return false;
    }

    public override function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
        if (menu != null) {
            menu.getEvent(name, sender, data, params);
        }
    }
}
