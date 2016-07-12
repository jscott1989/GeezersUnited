package me.jscott.ui;

import flash.events.KeyboardEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIButton;
import me.jscott.ui.controllers.Controller;

class OnScreenKeyboardMenu extends Menu {
    var inputText:FrtUIInputText;
    var targetField:FrtUIInputText;

    var inputTitle:String;

    public static inline var LOWERCASE = 0;
    public static inline var UPPERCASE = 1;
    public static inline var ALT = 2;

    var mode = 0;

    var keys = new Array<Array<Dynamic>>();

    public function new(inputTitle:String, targetField:FrtUIInputText, menuHost:MenuHost, menuable:Menuable) {
        this.inputTitle = inputTitle;
        this.targetField = targetField;
        super(menuHost, menuable);
    }

    override public function create():Void {
        _xml_id = "on_screen_keyboard";
        super.create();
        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        inputText = cast _ui.getFlxText("text");
        inputText.text = targetField.text;

        _ui.getFlxText("title").text = inputTitle;

        keys.push([_ui.getAsset("q"), "q", "Q", "1"]);
        keys.push([_ui.getAsset("w"), "w", "W", "2"]);
        keys.push([_ui.getAsset("e"), "e", "E", "3"]);
        keys.push([_ui.getAsset("r"), "r", "R", "4"]);
        keys.push([_ui.getAsset("t"), "t", "T", "5"]);
        keys.push([_ui.getAsset("y"), "y", "Y", "6"]);
        keys.push([_ui.getAsset("u"), "u", "U", "7"]);
        keys.push([_ui.getAsset("i"), "i", "I", "8"]);
        keys.push([_ui.getAsset("o"), "o", "O", "9"]);
        keys.push([_ui.getAsset("p"), "p", "P", "0"]);
        keys.push([_ui.getAsset("a"), "a", "A", "@"]);
        keys.push([_ui.getAsset("s"), "s", "S", "$"]);
        keys.push([_ui.getAsset("d"), "d", "D", "&"]);
        keys.push([_ui.getAsset("f"), "f", "F", "_"]);
        keys.push([_ui.getAsset("g"), "g", "G", "("]);
        keys.push([_ui.getAsset("h"), "h", "H", ")"]);
        keys.push([_ui.getAsset("j"), "j", "J", ":"]);
        keys.push([_ui.getAsset("k"), "k", "K", ";"]);
        keys.push([_ui.getAsset("l"), "l", "L", "\""]);
        keys.push([_ui.getAsset("z"), "z", "Z", "-"]);
        keys.push([_ui.getAsset("x"), "x", "X", "!"]);
        keys.push([_ui.getAsset("c"), "c", "C", "#"]);
        keys.push([_ui.getAsset("v"), "v", "V", "="]);
        keys.push([_ui.getAsset("b"), "b", "B", "/"]);
        keys.push([_ui.getAsset("n"), "n", "N", "+"]);
        keys.push([_ui.getAsset("m"), "m", "M", "?"]);
        keys.push([_ui.getAsset("alt"), "Alt", "Alt", "abc"]);
        keys.push([_ui.getAsset("shift"), "ABC", "abc", "abc"]);
    }

    public override function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
        if (name == Controller.A_BUTTON_EVENT) {

            if (Std.is(sender, FrtUIInputText)) {
                // We want to ensure that this does not result in an infinite loop of on screen keyboards
                return;
            }
        }
        super.getEvent(name, sender, data, params);
    }

    function swapCase() {
        if (mode == LOWERCASE) {
            // Go uppercase
            mode = UPPERCASE;
        } else {
            // lowercase
            mode = LOWERCASE;
        }

        for (i in keys) {
            var b:FlxUIButton = cast i[0];
            b.label.text = i[mode + 1];
        }
    }

    function goAlt() {
        if (mode == ALT) {
            // Go lowercase
            mode = LOWERCASE;
        } else {
            // Go alt
            mode = ALT;
        }

        for (i in keys) {
            var b:FlxUIButton = cast i[0];
            b.label.text = i[mode + 1];
        }
    }

    function done() {
        targetField.text = inputText.text;
        close();
    }

    public override function close() {
        FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        super.close();
    }

    public override function AButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        if (Std.is(sender, FlxUIButton)) {
            var s:FlxUIButton = cast sender;

            if (sender.name == "space") {
                inputText.text += " ";
            } else if (sender.name == "shift") {
                swapCase();
            } else if (sender.name == "alt") {
                goAlt();
            } else if (sender.name == "delete") {
                inputText.backspace();
            } else if (sender.name == "done") {
                done();
            } else {
                inputText.text += s.label.text;
            }
        }
    }

    private function onKeyDown(e:KeyboardEvent):Void {
        if (Std.is(frt_cursor.getSelected(), FrtUIInputText)) {
            var key = e.keyCode;

            if (key == 16 || key == 17 || key == 220 || key == 27 || key == 37 || key == 39 || key == 35 || key == 36 || key == 46) {
                return;
            }

            if (key == 8)  {
                // Backspace
                inputText.backspace();
            } else if (key == 13)  {
                // ENTER - return and update the input
                done();
            } else if (e.charCode == 0) {
                // Invalid character
            } else {
                inputText.text += String.fromCharCode(e.charCode);
            }

        }
    }

    public override function pressStart(controller:Controller, justPressed:Bool) {
        if (justPressed) {
            done();
        }
    }

    public override function pressLBumper(controller:Controller, justPressed:Bool) {
        if (justPressed) {
            swapCase();
        }
    }

    public override function pressRBumper(controller:Controller, justPressed:Bool) {
        if (justPressed) {
            swapCase();
        }
    }

    public override function pressSelect(controller:Controller, justPressed:Bool) {
        if (justPressed) {
            goAlt();
        }
    }

    public override function pressY(controller:Controller, justPressed:Bool) {
        if (justPressed) {
            inputText.text += " ";
        }
    }

    public override function pressX(controller:Controller, justPressed:Bool) {
        if (justPressed) {
            inputText.backspace();
        }
    }
}