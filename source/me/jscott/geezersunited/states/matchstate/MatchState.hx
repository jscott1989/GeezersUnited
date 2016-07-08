package me.jscott.geezersunited.states.matchstate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import me.jscott.geezersunited.Reg;
import flixel.math.FlxRandom;

class MatchState extends FlxState {

	public var movingPlayer:Player;
	public var movingXOffset:Float;
	public var movingYOffset:Float;

	var tacticsOverlay: TacticsOverlay;

	public var players = new Array<Player>();
	public var selectedPlayer:Player;

	var random = new FlxRandom();

	override public function create():Void {
		super.create();

		var pitch = new FlxSprite((FlxG.width / 2) - (Reg.PITCH_WIDTH / 2), (FlxG.height / 2) - (Reg.PITCH_HEIGHT / 2));
		pitch.makeGraphic(Reg.PITCH_WIDTH, Reg.PITCH_HEIGHT, FlxColor.GREEN);
		add(pitch);

		var goal1 = new Goal(pitch.x - Reg.GOAL_WIDTH, FlxG.height / 2 - (Reg.GOAL_HEIGHT / 2));
		var goal2 = new Goal(pitch.x + Reg.PITCH_WIDTH, FlxG.height / 2 - (Reg.GOAL_HEIGHT / 2));
		add(goal1);
		add(goal2);

		tacticsOverlay = new TacticsOverlay(this, pitch.x, pitch.y);
		add(tacticsOverlay);


		var ball = new Ball(pitch.x + Reg.PITCH_WIDTH / 2 - (Reg.BALL_WIDTH / 2), FlxG.height / 2 - (Reg.BALL_HEIGHT / 2));
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
				var player = new Player(this, pitch.x + x, y, colors[team]);
				players.push(player);
				add(player);
			}
		}

		selectedPlayer = players[0];
		selectedPlayer.select();

	}

	public function startMoving(player:Player, xOffset:Float, yOffset:Float) {
		movingPlayer = player;
		movingXOffset = xOffset;
		movingYOffset = yOffset;
	}

	public function stopMoving() {
		movingPlayer = null;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE) {
			this.selectedPlayer.deselect();
			//selectedPlayer = Random.fromArray(players);
			selectedPlayer = players[random.int(0,9)];
			selectedPlayer.select();
		}
		if(FlxG.keys.pressed.UP) {
			selectedPlayer.moveUp();
		}
		if(FlxG.keys.pressed.DOWN) {
			selectedPlayer.moveDown();
		}
		if(FlxG.keys.pressed.LEFT) {
			selectedPlayer.moveLeft();
		}
		if(FlxG.keys.pressed.RIGHT) {
			selectedPlayer.moveRight();
		}

		if (movingPlayer != null && !FlxG.mouse.pressed) {
			stopMoving();
		} else if (movingPlayer != null) {
			// Move him if needed...
			movingPlayer.addPoint(new FlxPoint(FlxG.mouse.x - movingXOffset, FlxG.mouse.y - movingYOffset));
		}
	}
}
