package me.jscott.geezersunited;

import flixel.math.FlxPoint;
import me.jscott.geezersunited.states.matchstate.Player;

/**
 * A formation for the 4 outfield players
 */
class Formation {
    public static var FORMATION_22 = new Formation(
        "2-2",
        new FlxPoint(0.2, -0.3),
        Player.D,
        new FlxPoint(0.2, 0.3),
        Player.D,
        new FlxPoint(0.4, -0.3),
        Player.A,
        new FlxPoint(0.4, 0.3),
        Player.A
    );

    public static var FORMATION_211 = new Formation(
        "2-1-1",
        new FlxPoint(0.2, -0.3),
        Player.D,
        new FlxPoint(0.2, 0.3),
        Player.D,
        new FlxPoint(0.3, 0),
        Player.M,
        new FlxPoint(0.5, 0),
        Player.A
    );

    public static var FORMATION_112 = new Formation(
        "1-1-2",
        new FlxPoint(0.2, -0.2),
        Player.D,
        new FlxPoint(0.3, 0.2),
        Player.M,
        new FlxPoint(0.4, -0.3),
        Player.A,
        new FlxPoint(0.4, 0.3),
        Player.A
    );

    public static var FORMATIONS = [FORMATION_22, FORMATION_211, FORMATION_112];

    public var name:String;
    public var points = new Array<FlxPoint>();
    public var roles = new Array<String>();

    public function new(name:String, pos2: FlxPoint, role2:String, pos3: FlxPoint, role3: String, pos4: FlxPoint, role4: String, pos5: FlxPoint, role5:String) {
        this.name = name;
        points.push(new FlxPoint(0.01, 0));
        roles.push(Player.GK);
        points.push(pos2);
        roles.push(role2);
        points.push(pos3);
        roles.push(role3);
        points.push(pos4);
        roles.push(role4);
        points.push(pos5);
        roles.push(role5);
    }
}