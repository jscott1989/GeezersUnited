package me.jscott.ui.controllers;

@:keep
interface Controllable {
    public function pressUp(controller:Controller, justPressed:Bool):Void;
    public function pressDown(controller:Controller, justPressed:Bool):Void;
    public function pressLeft(controller:Controller, justPressed:Bool):Void;
    public function pressRight(controller:Controller, justPressed:Bool):Void;

    public function pressStart(controller:Controller, justPressed:Bool):Void;
    public function pressSelect(controller:Controller, justPressed:Bool):Void;

    public function pressA(controller:Controller, justPressed:Bool):Void;
    public function pressB(controller:Controller, justPressed:Bool):Void;
    public function pressX(controller:Controller, justPressed:Bool):Void;
    public function pressY(controller:Controller, justPressed:Bool):Void;

    public function pressLBumper(controller:Controller, justPressed:Bool):Void;
    public function pressRBumper(controller:Controller, justPressed:Bool):Void;
}