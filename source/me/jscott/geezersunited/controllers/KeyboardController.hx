package me.jscott.geezersunited.controllers;

import flixel.FlxG;

class KeyboardController extends Controller {
    public function new() {
        
    }

    public override function RJustPressed() {
        return return FlxG.keys.justPressed.E;
    }
    public override function LJustPressed() {
        return return FlxG.keys.justPressed.W;
    }
}