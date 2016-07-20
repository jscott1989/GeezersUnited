package me.jscott.geezersunited.states.matchstate;

import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import me.jscott.Configuration;
import me.jscott.Utils;
import me.jscott.geezersunited.data.PlayerDefinition;
import me.jscott.geezersunited.data.TeamDefinition;

class Player extends FlxNapeSprite {
    var matchState: MatchState;
    var team:TeamDefinition;

    public static var GK = "GK";
    public static var D = "D";
    public static var M = "M";
    public static var A = "A";

    public var formationPosition:FlxPoint;
    public var player:PlayerDefinition;

    public function new(matchState:MatchState, player:PlayerDefinition, team: TeamDefinition) {
        this.team = team;
        this.matchState = matchState;
        this.player = player;
        super(0, 0);
        
        makeGraphic(Configuration.PLAYER_WIDTH, Configuration.PLAYER_HEIGHT, FlxColor.TRANSPARENT, true);
        drawSprite();
        createCircularBody(Configuration.BALL_WIDTH / 2);
        body.space = FlxNapeSpace.space;
    }

    public function move(elapsed:Float) {
        body.position.y -=  Math.cos(body.rotation) * Configuration.TRAVEL_SPEED * player.getStatMultiplier("speed") * elapsed;
        body.position.x += Math.sin(body.rotation) * Configuration.TRAVEL_SPEED * player.getStatMultiplier("speed") * elapsed;
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

        var newAngle = currentAngle + Configuration.ROTATION_SPEED * player.getStatMultiplier("speed") * elapsed;
        if (differenceUp > differenceDown) {
            newAngle = currentAngle - Configuration.ROTATION_SPEED * player.getStatMultiplier("speed") * elapsed;
        }

        if (Math.abs(newAngle - targetAngle) < Configuration.ROTATION_SPEED * player.getStatMultiplier("speed") * elapsed) {
            newAngle = targetAngle;
        }

        newAngle = Utils.normaliseAngle(newAngle);

        body.rotation = Utils.degToRad(newAngle);
    }

    function canKick(elapsed:Float) {
        // Check if the ball is in front of us, but not too far
        var position = new FlxPoint(body.position.x, body.position.y);
        var inFront = new FlxPoint(body.position.x + Math.sin(body.rotation) * Configuration.TRAVEL_SPEED * player.getStatMultiplier("speed") * elapsed, body.position.y -  Math.cos(body.rotation) * Configuration.TRAVEL_SPEED * player.getStatMultiplier("speed") * elapsed);
        var ballPosition = new FlxPoint(matchState.ball.body.position.x, matchState.ball.body.position.y);

        if (inFront.distanceTo(ballPosition) < position.distanceTo(ballPosition)) {
            // Is in front
            return (inFront.distanceTo(ballPosition)) < Configuration.KICK_DISTANCE;
        }

        return false;
    }

    public function kick(elapsed:Float) {
        if (canKick(elapsed)) {
            matchState.ball.kick(body.rotation, player.getStatMultiplier("power"));
        } else {
            trace("Fall over/miss kick");
        }
    }


    function drawSprite() {
        var c = this.team.getColor();
        if (highlightColor != null ){
            c = highlightColor;
        }

        FlxSpriteUtil.drawCircle(this, Std.int(Configuration.PLAYER_WIDTH / 2), Std.int(Configuration.PLAYER_WIDTH / 2), Std.int(Configuration.BALL_WIDTH / 2), c);
        FlxSpriteUtil.drawTriangle(this, 0, 0, Configuration.PLAYER_HEIGHT, c);

        var stampText:FlxText = new FlxText(0, 0, Std.int(width), Std.string(player.getID()), 20);        
        stampText.alignment = "center";
        stampText.color = this.team.getTextColor();
        stamp(stampText, 0, Std.int((height - stampText.height) / 2));

        stampText.text = player.getSurname();
        stampText.size = 9;
        stamp(stampText, 0, Std.int(height - stampText.height));

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