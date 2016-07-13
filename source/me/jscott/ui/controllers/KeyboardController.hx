package me.jscott.ui.controllers;

import flixel.FlxG;

using Reflect;

class KeyboardController extends Controller {
    var startButton:String;
    var selectButton:String;
    var upButton:String;
    var downButton:String;
    var leftButton:String;
    var rightButton:String;
    var aButton:String;
    var bButton:String;
    var xButton:String;
    var yButton:String;
    var lBumper:String;
    var rBumper:String;

    public function new(startButton:String = "ENTER",
                        selectButton:String = "ESCAPE",
                        upButton:String = "UP",
                        downButton:String = "DOWN",
                        leftButton:String = "LEFT",
                        rightButton:String = "RIGHT",
                        aButton:String = "Z",
                        bButton:String = "X",
                        xButton:String = "C",
                        yButton:String = "V",
                        lBumper:String = "B",
                        rBumper:String = "N") {
        this.startButton = startButton;
        this.selectButton = selectButton;
        this.upButton = upButton;
        this.downButton = downButton;
        this.leftButton = leftButton;
        this.rightButton = rightButton;
        this.aButton = aButton;
        this.bButton = bButton;
        this.xButton = xButton;
        this.yButton = yButton;
        this.lBumper = lBumper;
        this.rBumper = rBumper;

    }

    public override function startPressed() {
        return FlxG.keys.anyPressed([startButton]);
    }

    public override function selectPressed() {
        return FlxG.keys.anyPressed([selectButton]);
    }

    public override function upPressed() {
        return FlxG.keys.anyPressed([upButton]);
    }

    public override function downPressed() {
        return FlxG.keys.anyPressed([downButton]);
    }

    public override function leftPressed() {
        return FlxG.keys.anyPressed([leftButton]);
    }

    public override function rightPressed() {
        return FlxG.keys.anyPressed([rightButton]);
    }

    public override function aPressed() {
        return FlxG.keys.anyPressed([aButton]);
    }

    public override function bPressed() {
        return FlxG.keys.anyPressed([bButton]);
    }

    public override function xPressed() {
        return FlxG.keys.anyPressed([xButton]);
    }

    public override function yPressed() {
        return FlxG.keys.anyPressed([yButton]);
    }

    public override function lBumperPressed() {
        return FlxG.keys.anyPressed([lBumper]);
    }

    public override function rBumperPressed() {
        return FlxG.keys.anyPressed([rBumper]);
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