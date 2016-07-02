package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Goal extends FlxSprite {
	public function new(x: Float, y: Float) {
		super(x, y);
		makeGraphic(32, 200, FlxColor.YELLOW);
	}

	override public function update(elapsed:Float) {

    }
}