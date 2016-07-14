package me.jscott.geezersunited.data;

/**
 * This describes a team of players that exists in the game.
 */
class TeamDefinition {
    var id:Int;
    var name:String;
    var players:Array<PlayerDefinition>;

    public function getID() { return id; }
    public function getName() { return name; }
    public function getPlayers() { return players; }

    public function new(id:Int, name:String, players:Array<PlayerDefinition>) {
        this.id = id;
        this.name = name;
        this.players = players;
    }
}