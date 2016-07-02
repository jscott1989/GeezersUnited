package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite {
	public function new(x: Float, y: Float, color: FlxColor) {
		super(x, y);
		makeGraphic(64, 64, color);
	}

	override public function update(elapsed:Float) {

    }
}