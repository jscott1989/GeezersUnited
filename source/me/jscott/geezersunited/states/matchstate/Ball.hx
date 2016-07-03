package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import me.jscott.geezersunited.Reg;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class Ball extends FlxSprite {

	public var movingTween:FlxTween;

	public function calculateTravelTime(source:FlxPoint, target:FlxPoint, power:Int) {
        var distance = source.distanceTo(target);
        var distanceNormalized = distance * 0.03; // MAGIC NUMBER
        return distanceNormalized * ((100 - power) / 100);
    }

	public function kick(point:FlxPoint, power:Int) {
		if (movingTween != null) {
			movingTween.cancel();
			movingTween = null;
		}
		movingTween = FlxTween.tween(this, { x: point.x, y: point.y }, calculateTravelTime(new FlxPoint(x, y), point, power), {onComplete: function(tween:FlxTween) {
            movingTween = null;
        }});
	}

	public function new(x: Float, y: Float) {
		super(x, y);
		makeGraphic(Reg.BALL_WIDTH, Reg.BALL_HEIGHT, FlxColor.ORANGE);
	}

	override public function update(elapsed:Float) {

    }
}