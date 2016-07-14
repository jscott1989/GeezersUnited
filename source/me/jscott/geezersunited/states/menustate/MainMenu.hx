package me.jscott.geezersunited.states.menustate;

import flash.system.System;
import flixel.FlxG;
import me.jscott.geezersunited.states.matchstate.MatchState;
import me.jscott.geezersunited.states.leaguestate.LeagueState;
import me.jscott.ui.Menu;
import me.jscott.ui.controllers.Controller;
import me.jscott.geezersunited.data.Data;

class MainMenu extends Menu {
    var menuState:MenuState;

    public function new(menuState:MenuState) {
        Data.getData();
        super(menuState, menuState);
        this.menuState = menuState;
    }

    override public function create():Void {
        _xml_id = "main_menu";
        super.create();
    }

    override public function AButtonEvent(sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
        if (sender.name == "quit") {
            System.exit(0);
        } else if (sender.name == "friendly") {
            openMenu(new FriendlySelectTeamsMenu(menuState, this));
        } else if (sender.name == "league") {
            FlxG.switchState(new LeagueState(menuState.controllers, menuState.loadedGamepads));
        }
    }
}