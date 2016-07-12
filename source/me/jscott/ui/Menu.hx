package me.jscott.ui;

import flixel.FlxG;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.U;
import flixel.addons.ui.interfaces.IEventGetter;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import me.jscott.ui.controllers.Controllable;
import me.jscott.ui.controllers.Controller;
import me.jscott.ui.FrtUICursor;
import me.jscott.ui.FrtUI;

class Menu implements IEventGetter implements Controllable implements Menuable {
    var menuHost:MenuHost;
    var menuable:Menuable;
    var _ui:FlxUI;
    var _xml_id:String;
    var frt_cursor:FrtUICursor;

    var menu:Menu;

    public function new(menuHost:MenuHost, menuable:Menuable) {
        this.menuHost = menuHost;
        this.menuable = menuable;
    }

    public function reload() {
        if (_ui != null) {
            menuHost.removeFromUI(_ui);
        }

        var selectedName:String = null;

        if (frt_cursor != null) {
            menuHost.removeFromUI(frt_cursor);
            var selected = frt_cursor.getSelected();
            if (selected != null) {
                selectedName = selected.name;
            }
        }


        _ui = new FrtUI(menuHost, U.xml(_xml_id),this);

        _ui.getAsset("screen").width = FlxG.width / 2;

        menuHost.addToUI(_ui);
        
        frt_cursor = createCursor();
        frt_cursor.setDefaultKeys(0);

        menuHost.addToUI(frt_cursor);
        frt_cursor.addWidgetsFromUI(_ui);

        if (selectedName != null) {
            frt_cursor.jumpTo(_ui.getAsset(selectedName));
        } else {
            frt_cursor.findVisibleLocation(0);
        }
    }

    public function create():Void {
        reload();
    }

    private function createCursor() {
        return new FrtUICursor(menuHost, onCursorEvent);
    }

    public function close() {
        // We also need to close child menus
        if (menu != null) {
            menu.close();
        }

        menuHost.removeFromUI(_ui);
        menuHost.removeFromUI(frt_cursor);
        menuable.closeMenu();
    }

    public function openMenu(menu:Menu) {
        frt_cursor.visible = false;
        this.menu = menu;
        this.menu.create();
    }

    public function closeMenu() {
        frt_cursor.visible = true;
        this.menu = null;
    }

    public function update(elapsed:Float) {
        if (menu != null) {
            menu.update(elapsed);
        } else {
            // Check inputs
            for (controller in menuHost.getControllers()) {
                controller.update(elapsed, this);
            }

            frt_cursor.update(elapsed);
        }
    }

    public function pressUp(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            try {
                frt_cursor.pressUp();
            } catch(unknown:Dynamic) {
                // If there is nowhere for the cursor to go
            }
        }
    }
    
    public function pressDown(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            try {
                frt_cursor.pressDown();
            } catch(unknown:Dynamic) {
                // If there is nowhere for the cursor to go
            }
        }
    }

    public function pressLeft(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            try {
                frt_cursor.pressLeft();
            } catch(unknown:Dynamic) {
                // If there is nowhere for the cursor to go
            }
        }
    }

    public function pressRight(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            try {
                frt_cursor.pressRight();
            } catch(unknown:Dynamic) {
                // If there is nowhere for the cursor to go
            }
        }
    }

    public function pressA(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            frt_cursor.pressA();
        }
    }

    public function pressB(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            frt_cursor.pressB();
        }
    }

    public function pressX(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            frt_cursor.pressX();
        }
    }

    public function pressY(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            frt_cursor.pressY();
        }
    }

    public function pressStart(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            frt_cursor.pressStart();
        }
    }

    public function pressSelect(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            frt_cursor.pressSelect();
        }
    }

    public function pressLBumper(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            frt_cursor.pressLBumper();
        }
    }

    public function pressRBumper(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            frt_cursor.pressRBumper();
        }
    }

    public function onCursorEvent(code:String, target:IFlxUIWidget):Void 
    {
        var i:flixel.addons.ui.interfaces.IHasParams = cast target;

        if (i != null) {
            getEvent(code, target, null, i.params);
        }
    }

    public function setMode(mode_id:String,target_id:String=""):Void {
        _ui.setMode(mode_id, target_id);

        // Now move the cursor if neded
        frt_cursor.findVisibleLocation(frt_cursor.location);
    }

    public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
        if (menu != null) {
            menu.getEvent(name, sender, data, params);
            return;
        }
        
        if (name == Controller.A_BUTTON_EVENT) {

            // Special case - if we're pressing A on a FrtUIInputText then we need to
            // show the on screen keyboard
            if (Std.is(sender, FrtUIInputText)) {
                if (params != null) {
                    openMenu(new OnScreenKeyboardMenu(params[0], cast sender, menuHost, this));
                    return;
                } else {
                    // We eat it - this is probably a click on the on screen keyboard
                }
            }

            AButtonEvent(sender, data, params);
        } else if (name == Controller.B_BUTTON_EVENT) {
            BButtonEvent(sender, data, params);
        } else if (name == Controller.X_BUTTON_EVENT) {
            XButtonEvent(sender, data, params);
        } else if (name == Controller.Y_BUTTON_EVENT) {
            YButtonEvent(sender, data, params);
        } else if (name == Controller.START_BUTTON_EVENT) {
            StartButtonEvent(sender, data, params);
        } else if (name == Controller.SELECT_BUTTON_EVENT) {
            SelectButtonEvent(sender, data, params);
        } else if (name == Controller.L_BUMPER_EVENT) {
            LBumperEvent(sender, data, params);
        } else if (name == Controller.R_BUMPER_EVENT) {
            RBumperEvent(sender, data, params);
        }
    }

    public function getRequest(name:String, sender:IFlxUIWidget, data:Dynamic, ?params:Array<Dynamic>):Dynamic {
        return null;
    }

    public function AButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {

    }

    public function BButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        
    }

    public function XButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        
    }

    public function YButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        
    }

    public function SelectButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        
    }

    public function StartButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        
    }

    public function LBumperEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        
    }

    public function RBumperEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        
    }
}