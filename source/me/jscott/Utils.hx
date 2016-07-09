
package me.jscott;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * Useful functions that don't fit anywhere else
 */
class Utils
{
    /**
     * Move a sprite to the front of a members array.
     *
     * Pass in the "inFrontOf" to just move it in front of something else,
     * not to the front.
     */
    public static function bringToFront(members:Array<Dynamic>, member:Dynamic, inFrontOf:FlxSprite=null) {
        var i = members.indexOf(member);
        if (i > -1) {
            var target_index = members.length - 1;
            if (inFrontOf != null) {
                target_index = members.indexOf(inFrontOf);
            }

            while (i < target_index) {
                members[i] = members[i + 1];
                i++;
            }
            members[i] = member;
        }
    }

    /**
     * Move a sprite to the back of a members array.
     *
     * Pass in the "behind" to just move it behind something else,
     * not to the back.
     */
    public static function sendToBack(members:Array<Dynamic>, member:Dynamic, behind:FlxSprite=null) {
        var i = members.indexOf(member);
        if (i > -1) {
            var target_index = 0;
            if (behind != null) {
                target_index = members.indexOf(behind);
            }

            while (i > target_index) {
                members[i] = members[i - 1];
                i--;
            }
            members[i] = member;
        }
    }

    /**
    * Converts specified angle in radians to degrees.
    * @return angle in degrees (not normalized to 0...360)
    */
    public inline static function radToDeg(rad:Float):Float
    {
        return 180 / Math.PI * rad;
    }
    /**
    * Converts specified angle in degrees to radians.
    * @return angle in radians (not normalized to 0...Math.PI*2)
    */
    public inline static function degToRad(deg:Float):Float
    {
        return Math.PI / 180 * deg;
    }
}