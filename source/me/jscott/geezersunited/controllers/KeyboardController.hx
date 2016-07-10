package me.jscott.geezersunited.controllers;

import flixel.FlxG;

class KeyboardController extends Controller {
    public function new() {
        
    }
    public override function XJustPressed() {
        return FlxG.keys.justPressed.SPACE;
    }
    public override function RJustPressed() {
        return FlxG.keys.justPressed.E;
    }
    public override function LJustPressed() {
        return FlxG.keys.justPressed.Q;
    }
    public override function upPressed() {
        return FlxG.keys.pressed.W;
    }
    public override function downPressed() {
        return FlxG.keys.pressed.S;
    }
    public override function leftPressed() {
        return FlxG.keys.pressed.A;
    }
    public override function rightPressed() {
        return FlxG.keys.pressed.D;
    }
}