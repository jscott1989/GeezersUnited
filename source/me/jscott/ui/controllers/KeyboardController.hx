package me.jscott.ui.controllers;

import flixel.FlxG;

class KeyboardController extends Controller {
    public function new() {
        
    }

    public override function startPressed() {
        return FlxG.keys.pressed.ENTER;
    }

    public override function selectPressed() {
        return FlxG.keys.pressed.ESCAPE;
    }

    public override function upPressed() {
        return FlxG.keys.pressed.UP;
    }

    public override function downPressed() {
        return FlxG.keys.pressed.DOWN;
    }

    public override function leftPressed() {
        return FlxG.keys.pressed.LEFT;
    }

    public override function rightPressed() {
        return FlxG.keys.pressed.RIGHT;
    }

    public override function aPressed() {
        return FlxG.keys.pressed.Z;
    }

    public override function bPressed() {
        return FlxG.keys.pressed.X;
    }

    public override function xPressed() {
        return FlxG.keys.pressed.C;
    }

    public override function yPressed() {
        return FlxG.keys.pressed.V;
    }

    public override function lBumperPressed() {
        return FlxG.keys.pressed.B;
    }

    public override function rBumperPressed() {
        return FlxG.keys.pressed.N;
    }

    public override function isKeyboard() {
        return true;
    }

    public override function getAnalogAngle() {
        if (upPressed()) {
            if (leftPressed()) {
                return 315;
            } else if (rightPressed()) {
                return 45;
            } else {
                return 0;
            }
        } else if (downPressed()) {
            if (leftPressed()) {
                return 225;
            } else if (rightPressed()) {
                return 135;
            } else {
                return 180;
            }
        } else if (leftPressed()) {
            return 270;
        } else if (rightPressed()) {
            return 90;
        }

        return null;
    }

    public override function getAnalogVelocity() { 
        if (getAnalogAngle == null) {
            return 0;
        }
        return 1;
    }
}