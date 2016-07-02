package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import me.jscott.geezersunited.Reg;

class Goal extends FlxSprite {
	public function new(x: Float, y: Float) {
		super(x, y);
		makeGraphic(Reg.GOAL_WIDTH, Reg.GOAL_HEIGHT, FlxColor.YELLOW);
	}

	override public function update(elapsed:Float) {

    }
}