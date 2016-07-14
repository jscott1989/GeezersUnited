package me.jscott.geezersunited.states.matchstate;

import flixel.FlxCamera;
import flixel.FlxSprite;
import me.jscott.ui.Menu;
import me.jscott.ui.MenuHost;
import me.jscott.ui.controllers.Controller;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;

class SplitScreenMenuHost implements MenuHost {
    var menu:Menu;
    var controllers:Array<Controller>;

    var position:Int;
    var camera:FlxCamera;
    var uiGroup:FlxSpriteGroup;

    public function new(uiGroup:FlxSpriteGroup, camera:FlxCamera, controllers:Array<Controller>) {
        this.uiGroup = uiGroup;
        this.camera = camera;
        this.controllers = controllers;

        updateCamera();
    }

    public function addToUI(i:FlxSprite) {
        uiGroup.add(i);
    }

    public function removeFromUI(i:FlxSprite) {
        uiGroup.remove(i);
    }

    public function getCameraOffset() {
        return new FlxPoint(camera.scroll.x, camera.scroll.y);
    }

    public function isSplitScreen() {
        return true;
    }

    public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
        if (menu != null) {
            menu.getEvent(name, sender, data, params);
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

    public function updateCamera(camera:FlxCamera=null) {
        if (camera != null) {
            this.camera = camera;
        }

        this.camera.bgColor = FlxColor.TRANSPARENT;
        if (this.camera.scroll != null) {
            this.camera.scroll.set(this.uiGroup.x, this.uiGroup.y);
        }
    }

    public function update(elapsed:Float) {
        if (menu != null) {
            menu.update(elapsed);
        }
    }
}