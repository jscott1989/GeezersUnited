package me.jscott.geezersunited.states;

import flixel.FlxG;
import flixel.FlxState;
import me.jscott.geezersunited.states.matchstate.MatchState;

class MenuState extends FlxState {
	override public function create():Void {
		super.create();
	}

	override public function update(elapsed:Float):Void {
		FlxG.switchState(new MatchState());
		super.update(elapsed);
	}
}
