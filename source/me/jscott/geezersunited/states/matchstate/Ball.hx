package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import me.jscott.geezersunited.Reg;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.tweens.FlxTween;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxSpriteUtil;
import flixel.addons.nape.FlxNapeSpace;

class Ball extends FlxNapeSprite {

	public function new(x: Float, y: Float) {
		super(x, y);

                makeGraphic(Reg.BALL_WIDTH, Reg.BALL_HEIGHT, FlxColor.TRANSPARENT);
                FlxSpriteUtil.drawCircle(this, Std.int(Reg.BALL_WIDTH / 2), Std.int(Reg.BALL_WIDTH / 2), Std.int(Reg.BALL_WIDTH / 2), FlxColor.ORANGE);
                setSize(Reg.BALL_WIDTH, Reg.BALL_HEIGHT);
                createCircularBody(Reg.BALL_WIDTH / 2);

                setBodyMaterial(0.5, 0.5, 0.5, 2);
                body.space = FlxNapeSpace.space;
                physicsEnabled = true;
        		setDrag(0.99, 0.99);
	}

        public function kick(angle:Float) {
                body.velocity.y = 0 - Math.cos(angle) * Reg.KICK_SPEED;
                body.velocity.x = Math.sin(angle) * Reg.KICK_SPEED;
        }
}