package me.jscott.geezersunited.states.leaguestate;

import flash.system.System;
import flixel.FlxG;
import me.jscott.geezersunited.states.matchstate.MatchState;
import me.jscott.ui.Menu;
import me.jscott.ui.controllers.Controller;

class LeagueMenu extends Menu {

    var lastUsedController:Controller;
    var leagueState:LeagueState;

    public function new(leagueState:LeagueState) {
        super(leagueState, leagueState);
        this.leagueState = leagueState;
    }

    override public function create():Void {
        _xml_id = "league";
        super.create();
    }

    public override function pressA(controller:Controller, justPressed:Bool):Void {
        lastUsedController = controller;
        super.pressA(controller, justPressed);
    }
}