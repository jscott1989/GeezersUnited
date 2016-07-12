package me.jscott.ui.controllers;

import me.jscott.Configuration;

using Reflect;

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
        {controllerMethod: "startPressed", callbackMethod: "pressStart", active: false, timeActive:0.0},
        {controllerMethod: "selectPressed", callbackMethod: "pressSelect", active: false, timeActive:0.0},
        {controllerMethod: "upPressed", callbackMethod: "pressUp", active: false, timeActive:0.0},
        {controllerMethod: "downPressed", callbackMethod: "pressDown", active: false, timeActive:0.0},
        {controllerMethod: "leftPressed", callbackMethod: "pressLeft", active: false, timeActive:0.0},
        {controllerMethod: "rightPressed", callbackMethod: "pressRight", active: false, timeActive:0.0},
        {controllerMethod: "aPressed", callbackMethod: "pressA", active: false, timeActive:0.0},
        {controllerMethod: "bPressed", callbackMethod: "pressB", active: false, timeActive:0.0},
        {controllerMethod: "xPressed", callbackMethod: "pressX", active: false, timeActive:0.0},
        {controllerMethod: "yPressed", callbackMethod: "pressY", active: false, timeActive:0.0},
        {controllerMethod: "lBumperPressed", callbackMethod: "pressLBumper", active: false, timeActive:0.0},
        {controllerMethod: "rBumperPressed", callbackMethod: "pressRBumper", active: false, timeActive:0.0},
    ];

    public function update(elapsed:Float, controllable:Controllable = null):Void {
        for (button in BUTTONS) {
            if (this.field(button.controllerMethod)()) {
                // This has been pressed
                var justPressed = !button.active;

                if (!justPressed && button.timeActive >= Configuration.HOLD_REPEAT_TIMEOUT) {
                    justPressed = true;
                }

                button.active = true;

                if (justPressed) {
                    button.timeActive = 0.0;
                } else {
                    button.timeActive += elapsed;
                }

                Reflect.callMethod(controllable, controllable.field(button.callbackMethod), [this, justPressed]);
            } else {
                button.active = false;
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

    public function isKeyboard() {
        return false;
    }

}