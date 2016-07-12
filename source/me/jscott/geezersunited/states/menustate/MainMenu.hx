package me.jscott.geezersunited.states.menustate;

import flash.system.System;
import me.jscott.ui.Menu;
import me.jscott.ui.controllers.Controller;

class MainMenu extends Menu {

    var lastUsedController:Controller;

    override public function create():Void {
        _xml_id = "main_menu";
        super.create();
    }

    override public function AButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
        if (sender.name == "quit") {
            System.exit(0);
        }
        // } else if (sender.name == "joinnetworkgame") {
        //     openMenu(new NetworkGameMenu(menuHost, this));
        // } else if (params != null) {
        //     var type:String = params[0];
        //     if (type == "play") {
        //         startGame(params[1]);
        //     }
        // }
    }

    public override function pressA(controller:Controller, justPressed:Bool):Void {
        lastUsedController = controller;
        super.pressA(controller, justPressed);
    }
}