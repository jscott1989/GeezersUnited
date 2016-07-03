package me.jscott.geezersunited.states.matchstate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import me.jscott.geezersunited.Reg;
import flixel.text.FlxText;

class MatchState extends FlxState {

	public var moving:Movable;
	public var kicking:Movable;
	public var xOffset:Float;
	public var yOffset:Float;

	var tacticsOverlay: TacticsOverlay;

	public var ball:Ball;
	public var teams = new Array<Array<Player>>();
	public var players = new Array<Player>();

	public var timeRemaining:Float;
	public var score1:Int;
	public var score2:Int;

	var scoreText:FlxText;
	var timeText:FlxText;

	var pitch:FlxSprite;
	var goal1:Goal;
	var goal2:Goal;

	var startingPositions = [[40,-32], [140,-170], [140,100], [320,-130], [320,60]];

	override public function create():Void {
		super.create();

		pitch = new FlxSprite((FlxG.width / 2) - (Reg.PITCH_WIDTH / 2), (FlxG.height / 2) - (Reg.PITCH_HEIGHT / 2));
		pitch.makeGraphic(Reg.PITCH_WIDTH, Reg.PITCH_HEIGHT, FlxColor.GREEN);
		add(pitch);

		goal1 = new Goal(pitch.x - Reg.GOAL_WIDTH, FlxG.height / 2 - (Reg.GOAL_HEIGHT / 2));
		goal2 = new Goal(pitch.x + Reg.PITCH_WIDTH, FlxG.height / 2 - (Reg.GOAL_HEIGHT / 2));
		add(goal1);
		add(goal2);

		tacticsOverlay = new TacticsOverlay(this, pitch.x, pitch.y);
		add(tacticsOverlay);

		timeText = new FlxText(0, 10, FlxG.width, "2:30", 20);
		scoreText = new FlxText(0, timeText.y + timeText.height * 1.1, FlxG.width, "0 - 0", 40);
		timeText.alignment = "center";
		scoreText.alignment = "center";
		add(timeText);
		add(scoreText);

		score1 = 0;
		score2 = 0;


		ball = new Ball(pitch.x + Reg.PITCH_WIDTH / 2 - (Reg.BALL_WIDTH / 2), FlxG.height / 2 - (Reg.BALL_HEIGHT / 2));
		add(ball);

		var colors = [FlxColor.RED, FlxColor.BLUE];

		teams.push(new Array<Player>());
		teams.push(new Array<Player>());

		for (team in 0...2) {
			for (player in 0...5) {
				var x = startingPositions[player][0];
				var y = (FlxG.height / 2) + startingPositions[player][1];
				if (team == 1) {
					x = Reg.PITCH_WIDTH - x - Reg.PLAYER_WIDTH;
				}
				var player = new Player(this, pitch.x + x, y, colors[team]);
				players.push(player);
				teams[team].push(player);
				add(player);
			}
		}

		timeRemaining = 180;
	}

	public function startMoving(moving:Movable, xOffset:Float, yOffset:Float) {
		this.moving = moving;
		this.xOffset = xOffset;
		this.yOffset = yOffset;
	}

	public function startKicking(kicking:Movable, xOffset:Float, yOffset:Float) {
		this.kicking = kicking;
		this.xOffset = xOffset;
		this.yOffset = yOffset;
	}

	public function stopMoving() {
		moving = null;
	}

	public function stopKicking() {
		kicking = null;
	}

	public function resetState() {
		if (ball.movingTween != null) {
			ball.movingTween.cancel();
			ball.movingTween = null;
		}
		ball.x = pitch.x + Reg.PITCH_WIDTH / 2 - (Reg.BALL_WIDTH / 2);
		ball.y = FlxG.height / 2 - (Reg.BALL_HEIGHT / 2);

		for (team in 0...2) {
			for (player in 0...5) {
				var x = startingPositions[player][0];
				var y = (FlxG.height / 2) + startingPositions[player][1];
				if (team == 1) {
					x = Reg.PITCH_WIDTH - x - Reg.PLAYER_WIDTH;
				}
				teams[team][player].x = pitch.x + x;
				teams[team][player].y = y;
			}
		}
	}

	public function score(side:Int) {
		if (side == 1) {
			score1 += 1;
		} else {
			score2 += 1;
		}

		scoreText.text = Std.string(score1) + " - " + Std.string(score2);

		resetState();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		timeRemaining -= elapsed;
		var minutes = Std.int(timeRemaining/60);
		var seconds = Std.int(timeRemaining - minutes * 60);
		var secondsText = Std.string(seconds);
		if (secondsText.length == 1) {
			secondsText = "0" + secondsText;
		}
		timeText.text = Std.string(minutes) + ":" + secondsText;


		if (FlxG.overlap(ball, goal1)) {
			score(2);
		} else if (FlxG.overlap(ball, goal2)) {
			score(1);
		}

		if (moving != null && !FlxG.mouse.pressed) {
			stopMoving();
		} else if (moving != null) {
			// Move him if needed...
			moving.addPoint(new FlxPoint(FlxG.mouse.x - xOffset, FlxG.mouse.y - yOffset));
		} else if (kicking != null && !FlxG.mouse.pressedRight) {
			stopKicking();
		} else if (kicking != null) {
			// Adjust kicking angle
			kicking.setKickingTo(new FlxPoint(FlxG.mouse.x - xOffset, FlxG.mouse.y - yOffset));
		}
	}
}
