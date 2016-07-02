package me.jscott.geezersunited.states.matchstate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import me.jscott.geezersunited.Reg;

class MatchState extends FlxState {
	override public function create():Void {
		super.create();

		var pitch = new FlxSprite((FlxG.width / 2) - (Reg.PITCH_WIDTH / 2), (FlxG.height / 2) - (Reg.PITCH_HEIGHT / 2));
		pitch.makeGraphic(Reg.PITCH_WIDTH, Reg.PITCH_HEIGHT, FlxColor.GREEN);
		add(pitch);

		var goal1 = new Goal(pitch.x - Reg.GOAL_WIDTH, FlxG.height / 2 - (Reg.GOAL_HEIGHT / 2));
		var goal2 = new Goal(pitch.x + Reg.PITCH_WIDTH, FlxG.height / 2 - (Reg.GOAL_HEIGHT / 2));
		add(goal1);
		add(goal2);

		var ball = new Ball(Reg.PITCH_WIDTH / 2 - Reg.BALL_WIDTH, FlxG.height / 2 - Reg.BALL_HEIGHT);
		add(ball);

		var colors = [FlxColor.RED, FlxColor.BLUE];
		var startingPositions = [[40,-32], [140,-170], [140,100], [320,-130], [320,60]];

		for (team in 0...2) {
			for (player in 0...5) {
				var x = startingPositions[player][0];
				var y = (FlxG.height / 2) + startingPositions[player][1];
				if (team == 1) {
					x = Reg.PITCH_WIDTH - x - Reg.PLAYER_WIDTH;
				}
				var player = new Player(pitch.x + x, y, colors[team]);
				add(player);
			}
		}

	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
