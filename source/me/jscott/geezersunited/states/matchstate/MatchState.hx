package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class MatchState extends FlxState {
	override public function create():Void {
		super.create();

		var PLAYER_WIDTH = 64;
		var GOAL_HEIGHT = 200;

		// Standard Football Pitch dimensions are roughly 5/2 I think
		var PITCH_WIDTH = 1024;
		var PITCH_HEIGHT = Std.int(PITCH_WIDTH * (2/5));
		var pitch = new FlxSprite(0, (768 / 2) - (PITCH_HEIGHT / 2));
		pitch.makeGraphic(PITCH_WIDTH, PITCH_HEIGHT, FlxColor.GREEN);
		add(pitch);

		var goal1 = new Goal(0, 768 / 2 - (GOAL_HEIGHT / 2));
		var goal2 = new Goal(PITCH_WIDTH - 32, 768 / 2 - (GOAL_HEIGHT / 2));
		add(goal1);
		add(goal2);

		var colors = [FlxColor.RED, FlxColor.BLUE];
		var startingPositions = [[40,-32], [140,-170], [140,100], [320,-130], [320,60]];

		for (team in 0...2) {
			for (player in 0...5) {
				var x = startingPositions[player][0];
				var y = (768 / 2) + startingPositions[player][1];
				if (team == 1) {
					x = PITCH_WIDTH - x - PLAYER_WIDTH;
				}
				var player = new Player(x, y, colors[team]);
				add(player);
			}
		}

	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
