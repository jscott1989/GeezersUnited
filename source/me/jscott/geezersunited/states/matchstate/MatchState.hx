package me.jscott.geezersunited.states.matchstate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import me.jscott.Configuration;
import me.jscott.Utils;
import me.jscott.geezersunited.Formation;
import me.jscott.geezersunited.sides.AISide;
import me.jscott.geezersunited.sides.HumanSide;
import me.jscott.geezersunited.sides.Side;
import me.jscott.ui.Menu;
import me.jscott.ui.MenuHost;
import me.jscott.ui.controllers.Controller;
import me.jscott.ui.controllers.KeyboardController;
import me.jscott.ui.controllers.GamepadController;
import flixel.input.gamepad.FlxGamepad;
import me.jscott.geezersunited.data.TeamDefinition;

class MatchState extends FlxUIState implements MenuHost {

    var menu:Menu;

    var controllers:Array<Controller>;
    var loadedGamepads = new Array<FlxGamepad>();
    var defaultController:Controller;

    public var timeRemaining:Float;
    public var score1:Int;
    public var score2:Int;

    var inPlay = false;

    var scoreText:FlxText;
    var timeText:FlxText;

    var pitch: FlxSprite;

    var side1:Side;
    var side2:Side;

    public var ball:Ball;

    public var players= new Array<Array<Player>>();

    var leftGoalBase:FlxSprite;
    var rightGoalBase:FlxSprite;

    public var team1:TeamDefinition;
    public var team2:TeamDefinition;

    public function new(team1:TeamDefinition, team2:TeamDefinition, controllers:Array<Controller>, loadedGamepads:Array<FlxGamepad>, controller:Controller) {
        super();

        this.controllers = controllers;
        this.loadedGamepads = loadedGamepads;
        this.defaultController = controller;
        this.team1 = team1;
        this.team2 = team2;
    }

    public function setControllers(controllers1:Array<Controller>, controllers2:Array<Controller>) {
        if (controllers1.length == 0) {
            side1 = new AISide(0, this);
        } else {
            side1 = new HumanSide(0, this, controllers1);
        }

        if (controllers2.length == 0) {
            side2 = new AISide(1, this);
        } else {
            side2 = new HumanSide(1, this, controllers2);
        }

        resetState();
    }

    override public function create():Void {
        timeText = new FlxText(0, 10, FlxG.width, "2:30", 20);
        scoreText = new FlxText(0, timeText.y + timeText.height * 1.1, FlxG.width, team1.getName() + " 0 - 0 " + team2.getName(), 20);
        timeText.alignment = "center";
        scoreText.alignment = "center";
        add(timeText);
        add(scoreText);

        score1 = 0;
        score2 = 0;
        timeRemaining = 180;

        FlxNapeSpace.init();

        super.create();

        pitch = new FlxSprite((FlxG.width / 2) - (Configuration.PITCH_WIDTH / 2), (FlxG.height / 2) - (Configuration.PITCH_HEIGHT / 2));
        pitch.makeGraphic(Configuration.PITCH_WIDTH, Configuration.PITCH_HEIGHT, FlxColor.GREEN);
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

        openMenu(new SelectSideMenu(this, defaultController));
    }

    function createPlayers(isRight=false) {
        var r = new Array<Player>();
        for (i in 0...5) {
            var color = isRight ? FlxColor.BLUE : FlxColor.BLACK;
            var player = new Player(this, color, i + 1, 0, 0, 0, isRight);
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

            players[i].role = formation.roles[i];
        }
    }

    override public function update(elapsed:Float):Void {
        if (menu == null) {
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

                if (ball.body.position.x - Configuration.BALL_WIDTH / 2 > rightGoalBase.x && ball.body.position.y - Configuration.BALL_WIDTH / 2 > rightGoalBase.y && ball.body.position.y + Configuration.BALL_WIDTH / 2 < rightGoalBase.y + rightGoalBase.height) {
                    score(1);
                }

                if (ball.body.position.x + Configuration.BALL_WIDTH / 2 < leftGoalBase.x + leftGoalBase.width && ball.body.position.y - Configuration.BALL_WIDTH / 2 > leftGoalBase.y && ball.body.position.y + Configuration.BALL_WIDTH / 2 < leftGoalBase.y + leftGoalBase.height) {
                    score(2);
                }
            }
        } else {
            updateMenu(elapsed);
        }
    }

    function updateMenu(elapsed:Float) {
        // Check for new gamepads
        for (gamepad in FlxG.gamepads.getActiveGamepads()) {
            if (loadedGamepads.indexOf(gamepad) == -1) {
                controllers.push(new GamepadController(gamepad));
                loadedGamepads.push(gamepad);
            }
        }

        // TODO: Pass new controllers into menu
        menu.update(elapsed);
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

        if (side1 != null) {
            side1.resetState();
        }
        if (side2 != null) {
            side2.resetState();
        }
    }

    public function score(side:Int) {
        if (side == 1) {
            score1 += 1;
        } else {
            score2 += 1;
        }

        scoreText.text = team1.getName() + " " + Std.string(score1) + " - " + Std.string(score2) + " " + team2.getName();
        inPlay = false;

        haxe.Timer.delay(
            function() {
                resetState();
        },
        3000);
    }

    public function addToUI(i:FlxSprite) {
        add(i);
    }

    public function removeFromUI(i:FlxSprite) {
        remove(i);
    }

    public function getCameraOffset() {
        return new FlxPoint(0, 0);
    }

    public function isSplitScreen() {
        return false;
    }

    public override function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
        if (menu != null) {
            menu.getEvent(name, sender, data, params);
        }
    }

    public function openMenu(menu:Menu) {
        menu.create();
        this.menu = menu;
    }

    public function closeMenu() {
        this.menu = null;
    }

    public function getControllers():Array<Controller> {
        return controllers;
    }
}
