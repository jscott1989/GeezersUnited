package me.jscott.geezersunited.states.menustate;

import flixel.FlxG;
import flixel.addons.ui.FlxUIText;
import me.jscott.geezersunited.data.Data;
import me.jscott.geezersunited.states.matchstate.MatchState;
import me.jscott.ui.Menu;
import me.jscott.ui.Menuable;
import me.jscott.ui.controllers.Controller;

/**
 * Select teams for a friendly
 */
class FriendlySelectTeamsMenu extends Menu {

    var lastUsedController:Controller;

    var selectedTeams = [0, 1];

    var data:Data;

    var teamNames = new Array<FlxUIText>();

    var selectingTeam = 0;

    var menuState:MenuState;

    public function new(menuState:MenuState, menuable:Menuable) {
        this.menuState = menuState;
        super(menuState, menuable);
    }

    override public function create():Void {
        _xml_id = "friendly_select_teams";
        super.create();

        data = Data.getData();
        teamNames.push(cast _ui.getAsset("team1_name"));
        teamNames.push(cast _ui.getAsset("team2_name"));

        refreshTeamInfo();
    }

    function refreshTeamInfo() {
        for (i in 0...2) {
            var team = data.getTeams()[selectedTeams[i]];
            teamNames[i].text = team.getName();
        }
    }

    public override function pressLeft(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            selectedTeams[selectingTeam] -= 1;
            if (selectedTeams[selectingTeam] < 0) {
                selectedTeams[selectingTeam] = data.getNumberOfTeams() - 1;
            }
            refreshTeamInfo();
        }
    }

    public override function pressRight(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            selectedTeams[selectingTeam] += 1;
            if (selectedTeams[selectingTeam] >= data.getNumberOfTeams()) {
                selectedTeams[selectingTeam] = 0;
            }
            refreshTeamInfo();
        }
    }

    public override function pressA(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            lastUsedController = controller;
            selectingTeam += 1;
            if (selectingTeam == 2) {
                // We're done - move on to the game
                FlxG.switchState(new MatchState(data.getTeams()[selectedTeams[0]], data.getTeams()[selectedTeams[1]], menuState.controllers, menuState.loadedGamepads, lastUsedController));
            }
        }
    }

    public override function pressB(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            selectingTeam -= 1;
            if (selectingTeam < 0) {
                // Return to the menu
                close();
            }
        }
    }
}