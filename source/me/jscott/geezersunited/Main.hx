package me.jscott.geezersunited;

import flixel.FlxGame;
import me.jscott.geezersunited.states.menustate.MenuState;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(1024, 768, MenuState, 1, 60, 60, true));
	}
}