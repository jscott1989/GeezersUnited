package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import me.jscott.Configuration;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.tweens.FlxTween;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxSpriteUtil;
import flixel.addons.nape.FlxNapeSpace;
import nape.phys.BodyType;
import flixel.addons.nape.FlxNapeVelocity;
import flixel.text.FlxText;

class Player extends FlxNapeSprite {
    var matchState: MatchState;
    var num = 0;
    var teamColor:FlxColor;

    public static var GK = 0;
    public static var D = 1;
    public static var M = 2;
    public static var A = 3;

    public var formationPosition:FlxPoint;
    public var role:Int;

    public function new(matchState:MatchState, teamColor: FlxColor, num:Int, role:Int, x: Float, y: Float, isRight = false) {
        this.teamColor = teamColor;
        this.matchState = matchState;
        this.role = role;
        this.num = num;
        super(x, y);
        
        makeGraphic(Configuration.PLAYER_WIDTH, Configuration.PLAYER_HEIGHT, FlxColor.TRANSPARENT, true);
        drawSprite();
        createCircularBody(Configuration.BALL_WIDTH / 2);
        body.space = FlxNapeSpace.space;

        if (isRight) {
            body.rotation = Utils.degToRad(270);
        } else {
            body.rotation = Utils.degToRad(90);
        }
    }

    public function move(elapsed:Float) {
        body.position.y -=  Math.cos(body.rotation) * Configuration.TRAVEL_SPEED * elapsed;
        body.position.x += Math.sin(body.rotation) * Configuration.TRAVEL_SPEED * elapsed;
    }

    public function moveToPoint(point: FlxPoint, angle: Float, elapsed: Float) {
        var myPosition = new FlxPoint(body.position.x, body.position.y);
        if (point.distanceTo(myPosition) > 5) {
            var angle = Utils.normaliseAngle(myPosition.angleBetween(point));
            moveTowards(angle, elapsed);
        } else {
            turnTowards(angle, elapsed);
        }
    }

    public function moveTowards(targetAngle: Float, elapsed: Float) {
        var currentAngle = Utils.radToDeg(body.rotation);

        currentAngle = Utils.normaliseAngle(currentAngle);
        targetAngle = Utils.normaliseAngle(targetAngle);

        if (Math.abs(currentAngle - targetAngle) < 5) {
            move(elapsed);
        } else {
            turnTowards(targetAngle, elapsed);
        }
    }

    public function turnTowards(targetAngle: Float, elapsed: Float) {
        targetAngle = Utils.normaliseAngle(targetAngle);

        var currentAngle = Utils.radToDeg(body.rotation);
        // We need to figure out if it's quicker to go down or up
        var differenceUp = targetAngle - currentAngle;
        var differenceDown = currentAngle + 360 - targetAngle;
        if (targetAngle < currentAngle) {
            differenceUp = targetAngle + 360 - currentAngle;
            differenceDown = currentAngle - targetAngle;
        }

        var newAngle = currentAngle + Configuration.ROTATION_SPEED * elapsed;
        if (differenceUp > differenceDown) {
            newAngle = currentAngle - Configuration.ROTATION_SPEED * elapsed;
        }

        if (Math.abs(newAngle - targetAngle) < Configuration.ROTATION_SPEED * elapsed) {
            newAngle = targetAngle;
        }

        newAngle = Utils.normaliseAngle(newAngle);

        body.rotation = Utils.degToRad(newAngle);
    }

    function canKick(elapsed:Float) {
        // Check if the ball is in front of us, but not too far
        var position = new FlxPoint(body.position.x, body.position.y);
        var inFront = new FlxPoint(body.position.x + Math.sin(body.rotation) * Configuration.TRAVEL_SPEED * elapsed, body.position.y -  Math.cos(body.rotation) * Configuration.TRAVEL_SPEED * elapsed);
        var ballPosition = new FlxPoint(matchState.ball.body.position.x, matchState.ball.body.position.y);

        if (inFront.distanceTo(ballPosition) < position.distanceTo(ballPosition)) {
            // Is in front
            return (inFront.distanceTo(ballPosition)) < Configuration.KICK_DISTANCE;
        }

        return false;
    }

    public function kick(elapsed:Float) {
        if (canKick(elapsed)) {
            matchState.ball.kick(body.rotation);
        } else {
            trace("Fall over/miss kick");
        }
    }


    function drawSprite() {

        var c = this.teamColor;
        if (highlightColor != null ){
            c = highlightColor;
        }

        FlxSpriteUtil.drawCircle(this, Std.int(Configuration.PLAYER_WIDTH / 2), Std.int(Configuration.PLAYER_WIDTH / 2), Std.int(Configuration.BALL_WIDTH / 2), c);
        FlxSpriteUtil.drawTriangle(this, 0, 0, Configuration.PLAYER_HEIGHT, c);

        var stampText:FlxText = new FlxText(0, 0, Std.int(width), Std.string(num), 20);        
        stampText.alignment = "center";
        stamp(stampText, 0, Std.int((height - stampText.height) / 2));      
        stampText = null;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        body.angularVel = 0;
        body.velocity.x = 0;
        body.velocity.y = 0;
    }

    var highlightColor: FlxColor;

    public function setHighlighted(color:FlxColor) {
        this.highlightColor = color;
        drawSprite();
    }
}