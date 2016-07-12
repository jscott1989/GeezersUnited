package me.jscott.ui;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.addons.ui.FlxUICursor;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import me.jscott.ui.controllers.Controller;

class FrtUICursor extends FlxUICursor {
    var menuHost:MenuHost;

    public function new(menuHost:MenuHost, Callback:String->IFlxUIWidget->Void) {
        this.menuHost = menuHost;
        super(Callback);
    }

    public function pressUp():Void {
        _doInput(0, -1);
    }

    public function pressDown():Void {
        _doInput(0, 1);
    }

    public function pressLeft():Void {
        _doInput( -1, 0);
    }

    public function pressRight():Void {
        _doInput(1, 0);
    }

    public function pressA():Void {
        var currWidget:IFlxUIWidget = _widgets[location];
        if (currWidget == null) {
            return null;
        }

        callback(Controller.A_BUTTON_EVENT, currWidget);
    }

    public function pressB():Void {
        var currWidget:IFlxUIWidget = _widgets[location];
        if (currWidget == null) {
            return null;
        }

        callback(Controller.B_BUTTON_EVENT, currWidget);
    }

    public function pressX():Void {
        var currWidget:IFlxUIWidget = _widgets[location];
        if (currWidget == null) {
            return null;
        }

        callback(Controller.X_BUTTON_EVENT, currWidget);
    }

    public function pressY():Void {
        var currWidget:IFlxUIWidget = _widgets[location];
        if (currWidget == null) {
            return null;
        }

        callback(Controller.Y_BUTTON_EVENT, currWidget);
    }

    public function pressLBumper():Void {
        var currWidget:IFlxUIWidget = _widgets[location];
        if (currWidget == null) {
            return null;
        }

        callback(Controller.L_BUMPER_EVENT, currWidget);
    }

    public function pressRBumper():Void {
        var currWidget:IFlxUIWidget = _widgets[location];
        if (currWidget == null) {
            return null;
        }

        callback(Controller.R_BUMPER_EVENT, currWidget);
    }

    public function pressSelect():Void {
        var currWidget:IFlxUIWidget = _widgets[location];
        if (currWidget == null) {
            return null;
        }

        callback(Controller.SELECT_BUTTON_EVENT, currWidget);
    }

    public function pressStart():Void {
        var currWidget:IFlxUIWidget = _widgets[location];
        if (currWidget == null) {
            return null;
        }

        callback(Controller.START_BUTTON_EVENT, currWidget);
    }

    private override function _checkKeys():Void {
        // Just block this out so our own controls take over
    }

    public function getSelected():IFlxUIWidget {
        var currWidget:IFlxUIWidget = _widgets[location];
        return currWidget;
    }

    public override function update(elapsed:Float) {
        var mouseX:Float = FlxG.mouse.x;
        var mouseY:Float = FlxG.mouse.y;

        var c = menuHost.getCameraOffset();

        mouseX -= c.x;
        mouseY -= c.y;

        if (lastMouseX != mouseX || lastMouseY != mouseY)
        {
            var oldVis = visible;
            jumpToXY(mouseX, mouseY);
            visible = oldVis;
            
            lastMouseX = mouseX;
            lastMouseY = mouseY;
        }
    }
}