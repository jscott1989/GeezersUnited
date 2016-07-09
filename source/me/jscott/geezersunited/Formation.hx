package me.jscott.geezersunited;

import flixel.math.FlxPoint;

/**
 * A formation for the 4 outfield players
 */
class Formation {
    public static var FORMATION_22 = new Formation(
        new FlxPoint(0.2, -0.3),
        new FlxPoint(0.2, 0.3),
        new FlxPoint(0.4, -0.3),
        new FlxPoint(0.4, 0.3)
    );

    public var points = new Array<FlxPoint>();

    public function new(pos2: FlxPoint, pos3: FlxPoint, pos4: FlxPoint, pos5: FlxPoint) {
        points.push(new FlxPoint(0.01, 0));
        points.push(pos2);
        points.push(pos3);
        points.push(pos4);
        points.push(pos5);
    }
}