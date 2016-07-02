package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import me.jscott.geezersunited.Reg;

class Player extends FlxSprite {
	public function new(x: Float, y: Float, color: FlxColor) {
		super(x, y);
		makeGraphic(Reg.PLAYER_WIDTH, Reg.PLAYER_HEIGHT, color);

		// TODO: This needs to support right mouse presses too...
		FlxMouseEventManager.add(this, function(item:FlxSprite) {
            trace("A");
        });
	}

	override public function update(elapsed:Float) {

    }
}