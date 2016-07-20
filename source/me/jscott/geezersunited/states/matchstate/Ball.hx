package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import me.jscott.Configuration;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.tweens.FlxTween;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxSpriteUtil;
import flixel.addons.nape.FlxNapeSpace;

class Ball extends FlxNapeSprite {

	public function new(x: Float, y: Float) {
		super(x, y);

                makeGraphic(Configuration.BALL_WIDTH, Configuration.BALL_WIDTH, FlxColor.TRANSPARENT);
                FlxSpriteUtil.drawCircle(this, Std.int(Configuration.BALL_WIDTH / 2), Std.int(Configuration.BALL_WIDTH / 2), Std.int(Configuration.BALL_WIDTH / 2), FlxColor.ORANGE);
                setSize(Configuration.BALL_WIDTH, Configuration.BALL_WIDTH);
                createCircularBody(Configuration.BALL_WIDTH / 2);

                setBodyMaterial(0.5, 0.5, 0.5, 2);
                body.space = FlxNapeSpace.space;
                physicsEnabled = true;
        		setDrag(0.99, 0.99);
	}

        public function kick(angle:Float, power:Float) {
                body.velocity.y = 0 - Math.cos(angle) * Configuration.KICK_SPEED * power;
                body.velocity.x = Math.sin(angle) * Configuration.KICK_SPEED * power;
        }
}