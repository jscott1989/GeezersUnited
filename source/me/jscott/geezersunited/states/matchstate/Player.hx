package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import me.jscott.geezersunited.Reg;
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
    public function new(matchState:MatchState, teamColor: FlxColor, num:Int, x: Float, y: Float, isRight = false) {
        this.teamColor = teamColor;
        this.matchState = matchState;
        this.num = num;
        super(x, y);
        
        makeGraphic(Reg.PLAYER_WIDTH, Reg.PLAYER_HEIGHT, FlxColor.TRANSPARENT, true);
        drawSprite();
        createCircularBody(Reg.BALL_WIDTH / 2);
        body.space = FlxNapeSpace.space;

        if (isRight) {
            body.rotation = Utils.degToRad(270);
        } else {
            body.rotation = Utils.degToRad(90);
        }
    }

    public function move() {
        body.position.y -=  Math.cos(body.rotation) * Reg.TRAVEL_SPEED;
        body.position.x += Math.sin(body.rotation) * Reg.TRAVEL_SPEED;
    }

    function canKick() {
        // Check if the ball is in front of us, but not too far
        var position = new FlxPoint(body.position.x, body.position.y);
        var inFront = new FlxPoint(body.position.x + Math.sin(body.rotation) * Reg.TRAVEL_SPEED, body.position.y -  Math.cos(body.rotation) * Reg.TRAVEL_SPEED);
        var ballPosition = new FlxPoint(matchState.ball.body.position.x, matchState.ball.body.position.y);

        if (inFront.distanceTo(ballPosition) < position.distanceTo(ballPosition)) {
            // Is in front
            return (inFront.distanceTo(ballPosition)) < Reg.KICK_DISTANCE;
        }

        return false;
    }

    public function kick() {
        if (canKick()) {
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

        FlxSpriteUtil.drawCircle(this, Std.int(Reg.PLAYER_WIDTH / 2), Std.int(Reg.PLAYER_WIDTH / 2), Std.int(Reg.BALL_WIDTH / 2), c);
        FlxSpriteUtil.drawTriangle(this, 0, 0, Reg.PLAYER_HEIGHT, c);

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