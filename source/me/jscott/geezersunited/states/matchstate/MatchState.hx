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

class MatchState extends FlxState {

    var pitch: FlxSprite;

    var side1:Side;
    var side2:Side;

    public var players= new Array<Array<Player>>();

    override public function create():Void {
        side1 = new HumanSide(0, this, new KeyboardController());
        side2 = new AISide(1, this);

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

        var leftGoalBase = new FlxSprite(pitch.x - goalDepthPx, (pitch.y - wallWidth) + leftWall1.height);
        leftGoalBase.makeGraphic(goalDepthPx, goalHeightPx, FlxColor.RED);
        add(leftGoalBase);

        var leftGoalTop = new Wall(pitch.x - goalDepthPx, (pitch.y - wallWidth) + leftWall1.height, goalDepthPx, wallWidth);
        add(leftGoalTop);

        var leftGoalBottom = new Wall(pitch.x - goalDepthPx, (pitch.y - wallWidth) + leftWall1.height + goalHeightPx - wallWidth, goalDepthPx, wallWidth);
        add(leftGoalBottom);

        var leftGoalBack = new Wall(pitch.x - goalDepthPx - wallWidth, (pitch.y - wallWidth) + leftWall1.height, wallWidth, goalHeightPx);
        add(leftGoalBack);

        // Create right goal

        var rightGoalBase = new FlxSprite(pitch.x + pitch.width, (pitch.y - wallWidth) + leftWall1.height);
        rightGoalBase.makeGraphic(goalDepthPx, goalHeightPx, FlxColor.RED);
        add(rightGoalBase);

        var rightGoalTop = new Wall(pitch.x + pitch.width, (pitch.y - wallWidth) + rightWall1.height, goalDepthPx, wallWidth);
        add(rightGoalTop);

        var rightGoalBottom = new Wall(pitch.x + pitch.width, (pitch.y - wallWidth) + leftWall1.height + goalHeightPx - wallWidth, goalDepthPx, wallWidth);
        add(rightGoalBottom);

        var rightGoalBack = new Wall(pitch.x + pitch.width + goalDepthPx, (pitch.y - wallWidth) + leftWall1.height, wallWidth, goalHeightPx);
        add(rightGoalBack);
        

        var ball = new Ball(pitch.x + pitch.width / 2, pitch.y + pitch.height / 2);
        add(ball);


        players.push(setupPlayers(Formation.FORMATION_22));
        players.push(setupPlayers(Formation.FORMATION_22, true));

        for (player in players[0]) {
            add(player);
        }

        for (player in players[1]) {
            add(player);
        }
    }

    function setupPlayers(formation:Formation, isRight=false) {
        var r = new Array<Player>();

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
            var y = centre + yOffset;
            var player = new Player(i + 1, x, y);
            r.push(player);
        }


        return r;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        side1.update(elapsed);
        side2.update(elapsed);
    }
}
