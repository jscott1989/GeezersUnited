package me.jscott.ui.controllers;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.input.gamepad.FlxGamepadInputID;

class GamepadController extends Controller {

    public var gamepad:FlxGamepad;

    public function new(gamepad:FlxGamepad) {
        this.gamepad = gamepad;
    }

    public override function startPressed() {
        return gamepad.pressed.START;
    }

    public override function selectPressed() {
        return gamepad.pressed.BACK;
    }

    public override function upPressed() {
        return gamepad.pressed.DPAD_UP || gamepad.analog.value.LEFT_STICK_Y < -0.3;
    }

    public override function downPressed() {
        return gamepad.pressed.DPAD_DOWN || gamepad.analog.value.LEFT_STICK_Y > 0.3;
    }

    public override function leftPressed() {
        return gamepad.pressed.DPAD_LEFT || gamepad.analog.value.LEFT_STICK_X < -0.3;
    }

    public override function rightPressed() {
        return gamepad.pressed.DPAD_RIGHT || gamepad.analog.value.LEFT_STICK_X > 0.3;
    }

    public override function aPressed() {
        return gamepad.pressed.A;
    }

    public override function bPressed() {
        return gamepad.pressed.B;
    }

    public override function xPressed() {
        return gamepad.pressed.X;
    }

    public override function yPressed() {
        return gamepad.pressed.Y;
    }

    public override function lBumperPressed() {
        return gamepad.pressed.LEFT_SHOULDER;
    }

    public override function rBumperPressed() {
        return gamepad.pressed.RIGHT_SHOULDER;
    }

    public override function getAnalogAngle() {
        var p = new FlxPoint(gamepad.getXAxis(FlxGamepadInputID.LEFT_ANALOG_STICK), gamepad.getYAxis(FlxGamepadInputID.LEFT_ANALOG_STICK));

        if (p.x == 0 && p.y == 0) {
            return null;
        }

        return Utils.normaliseAngle(new FlxPoint(0, 0).angleBetween(p));
    }

    public override function getAnalogVelocity() { 
        if (getAnalogAngle == null) {
            return 0.0;
        }
        
        var p = new FlxPoint(gamepad.getXAxis(FlxGamepadInputID.LEFT_ANALOG_STICK), gamepad.getYAxis(FlxGamepadInputID.LEFT_ANALOG_STICK));

        return new FlxPoint(0, 0).distanceTo(p);
    }
}