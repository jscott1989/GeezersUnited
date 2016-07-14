package me.jscott.geezersunited.data;

import yaml.Yaml;
import yaml.util.ObjectMap;

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
            players.set(cast player.get("id"), new PlayerDefinition(cast player.get("id"), player.get("name")));
         }

         p = cast data.get("teams");
         for (team in p) {
            var teamPlayers = new Array<PlayerDefinition>();
            var playerIDs:Array<Int> = cast team.get("players");
            for (playerID in playerIDs) {
                teamPlayers.push(players[playerID]);
            }
            teams.set(cast team.get("id"), new TeamDefinition(cast team.get("id"), team.get("name"), teamPlayers));
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