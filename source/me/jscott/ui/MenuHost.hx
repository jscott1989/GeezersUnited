package me.jscott.ui;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import me.jscott.ui.controllers.Controller;

interface MenuHost extends Menuable {
    public function getControllers():Array<Controller>;

    public function addToUI(i:FlxSprite):Void;
    public function removeFromUI(i:FlxSprite):Void;

    public function isSplitScreen():Bool;
    public function getCameraOffset():FlxPoint;
}