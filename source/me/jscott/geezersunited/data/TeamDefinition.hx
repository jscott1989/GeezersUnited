package me.jscott.geezersunited.data;

import me.jscott.geezersunited.Formation;
import flixel.util.FlxColor;

/**
 * This describes a team of players that exists in the game.
 */
class TeamDefinition {
    var id:Int;
    var name:String;
    var players:Array<PlayerDefinition>;
    var formation:Formation;
    var color:FlxColor;
    var text_color:FlxColor;

    public function getID() { return id; }
    public function getName() { return name; }
    public function getPlayers() { return players; }
    public function getFormation() { return formation; }
    public function getColor() { return color; }
    public function getTextColor() { return text_color; }

    public function new(id:Int, name:String, players:Array<PlayerDefinition>, formation:Formation, color:FlxColor, text_color:FlxColor) {
        this.id = id;
        this.name = name;
        this.players = players;
        this.formation = formation;
        this.color = color;
        this.text_color = text_color;
    }
}