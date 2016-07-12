package me.jscott.ui;

import flash.events.KeyboardEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUITypedButton;
import flixel.addons.ui.interfaces.ICursorPointable;
import flixel.util.FlxColor;

class FrtUIInputText extends FlxUIInputText implements ICursorPointable {
    public function new(X:Float = 0, Y:Float = 0, Width:Int = 150, ?Text:String, size:Int = 8, TextColor:Int = FlxColor.BLACK, BackgroundColor:Int = FlxColor.WHITE, EmbeddedFont:Bool = true) {
        super(X, Y, Width, Text, size, TextColor, BackgroundColor, EmbeddedFont);
        FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    override public function update(elapsed:Float):Void 
    {
        super.update(elapsed);
        hasFocus = false;
        if (FlxG.mouse.justPressed) 
        {
            if (FlxG.mouse.overlaps(this)) 
            {
                // We've clicked - open the on-screen keyboard
                FlxUI.event(FlxUITypedButton.CLICK_EVENT, this, null, params);
            }
        }
    }

    public function forceKeyDown(e:KeyboardEvent) {
        onKeyDown(e);
    }

    public function backspace() {
        if (text.length > 0) {
            text = text.substring(0, text.length - 1);
        }
    }

}