package me.jscott.geezersunited.states.menustate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxPoint;
import me.jscott.ui.Menu;
import me.jscott.ui.MenuHost;
import me.jscott.ui.controllers.Controller;
import me.jscott.ui.controllers.GamepadController;
import me.jscott.ui.controllers.KeyboardController;

class MenuState extends FlxUIState implements MenuHost {

    var controllers:Array<Controller>;
    var loadedGamepads = new Array<flixel.input.gamepad.FlxGamepad>();

    var menu:Menu;

    public function new(controllers:Array<Controller>=null) {
        super();

        if (controllers == null) {
            // We want to allow all controllers
            controllers = new Array<Controller>();
            controllers.push(new KeyboardController());

            for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                if (loadedGamepads.indexOf(gamepad) == -1) {
                    controllers.push(new GamepadController(gamepad));
                    loadedGamepads.push(gamepad);
                }
            }
        }
        this.controllers = controllers;
    }

	override public function create():Void {
        super.create();
        openMenu(new MainMenu(this, this));
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

        // TODO: Pass new controllers into menu

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
