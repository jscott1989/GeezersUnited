package me.jscott.geezersunited;

import flixel.math.FlxPoint;
import me.jscott.geezersunited.states.matchstate.Player;

/**
 * A formation for the 4 outfield players
 */
class Formation {
    public static var FORMATION_22 = new Formation(
        new FlxPoint(0.2, -0.3),
        Player.D,
        new FlxPoint(0.2, 0.3),
        Player.D,
        new FlxPoint(0.4, -0.3),
        Player.A,
        new FlxPoint(0.4, 0.3),
        Player.A
    );

    public var points = new Array<FlxPoint>();
    public var roles = new Array<Int>();

    public function new(pos2: FlxPoint, role2:Int, pos3: FlxPoint, role3: Int, pos4: FlxPoint, role4: Int, pos5: FlxPoint, role5:Int) {
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