package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import me.jscott.geezersunited.Reg;

class Ball extends FlxSprite {
	public function new(x: Float, y: Float) {
		super(x, y);
		makeGraphic(Reg.BALL_WIDTH, Reg.BALL_HEIGHT, FlxColor.ORANGE);
	}

	override public function update(elapsed:Float) {

    }
}