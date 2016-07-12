package me.jscott.ui.controllers;

import me.jscott.Configuration;

using Reflect;

@:keep
class Controller {
    // We use click_button so that left clicks also map to this
    public static inline var A_BUTTON_EVENT:String = "click_button";
    public static inline var B_BUTTON_EVENT:String = "b_button";
    public static inline var X_BUTTON_EVENT:String = "x_button";
    public static inline var Y_BUTTON_EVENT:String = "y_button";
    public static inline var L_BUMPER_EVENT:String = "l_bumper";
    public static inline var R_BUMPER_EVENT:String = "r_bumper";
    public static inline var START_BUTTON_EVENT:String = "start_button";
    public static inline var SELECT_BUTTON_EVENT:String = "select_button";

    public var BUTTONS = [
        {controllerMethod: "startPressed", callbackMethod: "pressStart", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "selectPressed", callbackMethod: "pressSelect", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "upPressed", callbackMethod: "pressUp", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "downPressed", callbackMethod: "pressDown", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "leftPressed", callbackMethod: "pressLeft", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "rightPressed", callbackMethod: "pressRight", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "aPressed", callbackMethod: "pressA", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "bPressed", callbackMethod: "pressB", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "xPressed", callbackMethod: "pressX", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "yPressed", callbackMethod: "pressY", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "lBumperPressed", callbackMethod: "pressLBumper", justPressed: false, active: false, timeActive:0.0},
        {controllerMethod: "rBumperPressed", callbackMethod: "pressRBumper", justPressed: false, active: false, timeActive:0.0},
    ];

    public function update(elapsed:Float, controllable:Controllable = null):Void {
        for (button in BUTTONS) {
            if (this.field(button.controllerMethod)()) {
                // This has been pressed
                button.justPressed = !button.active;

                if (!button.justPressed && button.timeActive >= Configuration.HOLD_REPEAT_TIMEOUT) {
                    button.justPressed = true;
                }

                button.active = true;

                if (button.justPressed) {
                    button.timeActive = 0.0;
                } else {
                    button.timeActive += elapsed;
                }

                if (controllable != null) {
                    Reflect.callMethod(controllable, controllable.field(button.callbackMethod), [this, button.justPressed]);
                }
            } else {
                button.active = false;
                button.justPressed = false;
            }
        }
    }
    

    public function startPressed() {return false;}
    public function selectPressed() {return false;}
    public function upPressed() {return false;}
    public function downPressed() {return false;}
    public function leftPressed() {return false;}
    public function rightPressed() {return false;}
    public function aPressed() {return false;}
    public function bPressed() {return false;}
    public function xPressed() {return false;}
    public function yPressed() {return false;}
    public function lBumperPressed() {return false;}
    public function rBumperPressed() {return false;}

    public function startJustPressed() { return BUTTONS[0].justPressed; }
    public function selectJustPressed() { return BUTTONS[1].justPressed; }
    public function upJustPressed() { return BUTTONS[2].justPressed; }
    public function downJustPressed() { return BUTTONS[3].justPressed; }
    public function leftJustPressed() { return BUTTONS[4].justPressed; }
    public function rightJustPressed() { return BUTTONS[5].justPressed; }
    public function aJustPressed() { return BUTTONS[6].justPressed; }
    public function bJustPressed() { return BUTTONS[7].justPressed; }
    public function xJustPressed() { return BUTTONS[8].justPressed; }
    public function yJustPressed() { return BUTTONS[9].justPressed; }
    public function lBumperJustPressed() { return BUTTONS[10].justPressed; }
    public function rBumperJustPressed() { return BUTTONS[11].justPressed; }

    public function isKeyboard() {
        return false;
    }

}