package me.jscott.geezersunited.data;

import me.jscott.geezersunited.Formation;
import yaml.Yaml;
import yaml.util.ObjectMap;
import flixel.util.FlxColor;

/**
 * This represents the team and player database
 */
class Data {

    static var data:Data;
    public static function getData() {
        if (data == null) {
            data = new Data();
        }
        return data;
    }

    var players = new Map<Int, PlayerDefinition>();
    var teams = new Map<Int, TeamDefinition>();
    var numberOfTeams = 0;

    public function new() {
         var data:AnyObjectMap = Yaml.read("assets/data/teams.yaml");
         var p:Array<Dynamic> = cast data.get("players");
         for (player in p) {
            var stats = new Map<String, Int>();
            for (k in Configuration.STATS) {
                stats[k] = cast player.get("stats").get(k);
            }
            players.set(cast player.get("id"), new PlayerDefinition(cast player.get("id"), player.get("name"), stats));
         }

         var formationsByName = new Map<String, Formation>();
         for (formation in Formation.FORMATIONS) {
            formationsByName[formation.name] = formation;
         }

         p = cast data.get("teams");
         for (team in p) {
            var teamPlayers = new Array<PlayerDefinition>();
            var playerIDs:Array<Int> = cast team.get("players");
            for (playerID in playerIDs) {
                teamPlayers.push(players[playerID]);
            }
            teams.set(cast team.get("id"), new TeamDefinition(cast team.get("id"), team.get("name"), teamPlayers, formationsByName[team.get("formation")], FlxColor.fromString(team.get("color")), FlxColor.fromString(team.get("text_color"))));
            numberOfTeams += 1;
         }
    }

    public function getPlayers() {
        return players;
    }

    public function getTeams() {
        return teams;
    }

    public function getNumberOfTeams() {
        return numberOfTeams;
    }
}