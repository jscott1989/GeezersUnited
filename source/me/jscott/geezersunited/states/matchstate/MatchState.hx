package me.jscott.geezersunited.states.matchstate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSpace;
import flixel.util.FlxColor;
import me.jscott.geezersunited.Reg;
import me.jscott.geezersunited.controllers.KeyboardController;
import me.jscott.geezersunited.sides.AISide;
import me.jscott.geezersunited.sides.HumanSide;
import me.jscott.geezersunited.sides.Side;
import flixel.text.FlxText;
import flixel.math.FlxPoint;

class MatchState extends FlxState {

    public var timeRemaining:Float;
    public var score1:Int;
    public var score2:Int;

    var inPlay = true;

    var scoreText:FlxText;
    var timeText:FlxText;

    var pitch: FlxSprite;

    var side1:Side;
    var side2:Side;

    public var ball:Ball;

    public var players= new Array<Array<Player>>();

    var leftGoalBase:FlxSprite;
    var rightGoalBase:FlxSprite;

    override public function create():Void {
        side1 = new HumanSide(0, this, new KeyboardController());
        side2 = new AISide(1, this);

        timeText = new FlxText(0, 10, FlxG.width, "2:30", 20);
        scoreText = new FlxText(0, timeText.y + timeText.height * 1.1, FlxG.width, "0 - 0", 40);
        timeText.alignment = "center";
        scoreText.alignment = "center";
        add(timeText);
        add(scoreText);

        score1 = 0;
        score2 = 0;
        timeRemaining = 180;

        FlxNapeSpace.init();

        super.create();

        pitch = new FlxSprite((FlxG.width / 2) - (Reg.PITCH_WIDTH / 2), (FlxG.height / 2) - (Reg.PITCH_HEIGHT / 2));
        pitch.makeGraphic(Reg.PITCH_WIDTH, Reg.PITCH_HEIGHT, FlxColor.GREEN);
        add(pitch);

        var wallWidth = 10;
        var goalHeight = 0.6;
        var goalDepth = 0.2;

        // Create top and bottom barriers

        var topWall = new Wall(pitch.x, pitch.y - wallWidth, Std.int(pitch.width), wallWidth);
        add(topWall);

        var bottomWall = new Wall(pitch.x, pitch.y + pitch.height, Std.int(pitch.width), wallWidth);
        add(bottomWall);

        // Create left barrier with a space for a goal

        var leftWall1 = new Wall(pitch.x - wallWidth, pitch.y - wallWidth, wallWidth, Std.int((pitch.height + wallWidth * 2) * ((1 - goalHeight) / 2)));
        add(leftWall1);

        var leftWall2 = new Wall(pitch.x - wallWidth, (pitch.y - wallWidth) + (pitch.height + wallWidth * 2) * ((1 + goalHeight) / 2), wallWidth, Std.int((pitch.height + wallWidth * 2) * ((1 - goalHeight) / 2)));
        add(leftWall2);


        // Create right barrier with a space for a goal

        var rightWall1 = new Wall(pitch.x + pitch.width, pitch.y - wallWidth, wallWidth, Std.int((pitch.height + wallWidth * 2) * ((1 - goalHeight) / 2)));
        add(rightWall1);

        var rightWall2 = new Wall(pitch.x + pitch.width, (pitch.y - wallWidth) + (pitch.height + wallWidth * 2) * ((1 + goalHeight) / 2), wallWidth, Std.int((pitch.height + wallWidth * 2) * ((1 - goalHeight) / 2)));
        add(rightWall2);

        // Create left goal

        var goalDepthPx = Std.int(pitch.height * goalDepth);
        var goalHeightPx = Std.int((pitch.height + wallWidth * 2) * goalHeight);

        leftGoalBase = new FlxSprite(pitch.x - goalDepthPx, (pitch.y - wallWidth) + leftWall1.height);
        leftGoalBase.makeGraphic(goalDepthPx, goalHeightPx, FlxColor.RED);
        add(leftGoalBase);

        var leftGoalTop = new Wall(pitch.x - goalDepthPx, (pitch.y - wallWidth) + leftWall1.height, goalDepthPx, wallWidth);
        add(leftGoalTop);

        var leftGoalBottom = new Wall(pitch.x - goalDepthPx, (pitch.y - wallWidth) + leftWall1.height + goalHeightPx - wallWidth, goalDepthPx, wallWidth);
        add(leftGoalBottom);

        var leftGoalBack = new Wall(pitch.x - goalDepthPx - wallWidth, (pitch.y - wallWidth) + leftWall1.height, wallWidth, goalHeightPx);
        add(leftGoalBack);

        // Create right goal

        rightGoalBase = new FlxSprite(pitch.x + pitch.width, (pitch.y - wallWidth) + leftWall1.height);
        rightGoalBase.makeGraphic(goalDepthPx, goalHeightPx, FlxColor.RED);
        add(rightGoalBase);

        var rightGoalTop = new Wall(pitch.x + pitch.width, (pitch.y - wallWidth) + rightWall1.height, goalDepthPx, wallWidth);
        add(rightGoalTop);

        var rightGoalBottom = new Wall(pitch.x + pitch.width, (pitch.y - wallWidth) + leftWall1.height + goalHeightPx - wallWidth, goalDepthPx, wallWidth);
        add(rightGoalBottom);

        var rightGoalBack = new Wall(pitch.x + pitch.width + goalDepthPx, (pitch.y - wallWidth) + leftWall1.height, wallWidth, goalHeightPx);
        add(rightGoalBack);
        

        ball = new Ball(pitch.x + pitch.width / 2, pitch.y + pitch.height / 2);
        add(ball);


        players.push(createPlayers());
        players.push(createPlayers(true));

        for (player in players[0]) {
            add(player);
        }

        for (player in players[1]) {
            add(player);
        }

        resetState();
    }

    function createPlayers(isRight=false) {
        var r = new Array<Player>();
        for (i in 0...5) {
            var color = isRight ? FlxColor.BLUE : FlxColor.BLACK;
            var player = new Player(this, color, i + 1, 0, 0, isRight);
            r.push(player);
        }
        return r;
    }

    function setupPlayers(players:Array<Player>, formation:Formation, isRight=false) {
        var centre = pitch.y + pitch.height / 2;
        var startPos = pitch.x;
        if (isRight) {
            startPos = pitch.x + pitch.width;
        }

        for (i in 0...5) {
            var xOffset = pitch.width * formation.points[i].x;
            var yOffset = pitch.height * formation.points[i].y;

            var x = startPos + xOffset;
            if (isRight) {
                x = startPos - xOffset;
            }
            var color = isRight ? FlxColor.BLUE : FlxColor.BLACK;
            var y = centre + yOffset;
            players[i].body.position.x = x;
            players[i].body.position.y = y;

            players[i].formationPosition = new FlxPoint(x, y);

            if (isRight) {
                players[i].body.rotation = Utils.degToRad(270);
            } else {
                players[i].body.rotation = Utils.degToRad(90);
            }
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        side1.update(elapsed);
        side2.update(elapsed);

        if (inPlay) {
            timeRemaining -= elapsed;
            var minutes = Std.int(timeRemaining/60);
            var seconds = Std.int(timeRemaining - minutes * 60);
            var secondsText = Std.string(seconds);
            if (secondsText.length == 1) {
                secondsText = "0" + secondsText;
            }
            timeText.text = Std.string(minutes) + ":" + secondsText;

            if (ball.body.position.x - Reg.BALL_WIDTH / 2 > rightGoalBase.x && ball.body.position.y - Reg.BALL_WIDTH / 2 > rightGoalBase.y && ball.body.position.y + Reg.BALL_WIDTH / 2 < rightGoalBase.y + rightGoalBase.height) {
                score(1);
            }

            if (ball.body.position.x + Reg.BALL_WIDTH / 2 < leftGoalBase.x + leftGoalBase.width && ball.body.position.y - Reg.BALL_WIDTH / 2 > leftGoalBase.y && ball.body.position.y + Reg.BALL_WIDTH / 2 < leftGoalBase.y + leftGoalBase.height) {
                score(2);
            }
        }
    }

    function resetState() {
        inPlay = true;
        setupPlayers(players[0], Formation.FORMATION_22);
        setupPlayers(players[1], Formation.FORMATION_22, true);
        ball.body.position.x = pitch.x + pitch.width / 2;
        ball.body.position.y = pitch.y + pitch.height / 2;
        ball.body.angularVel = 0;
        ball.body.velocity.x = 0;
        ball.body.velocity.y = 0;

        side1.resetState();
        side2.resetState();
    }

    public function score(side:Int) {
        if (side == 1) {
            score1 += 1;
        } else {
            score2 += 1;
        }

        scoreText.text = Std.string(score1) + " - " + Std.string(score2);
        inPlay = false;

        haxe.Timer.delay(
            function() {
                resetState();
        },
        3000);
    }
}
