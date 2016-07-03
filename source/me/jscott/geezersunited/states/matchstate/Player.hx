package me.jscott.geezersunited.states.matchstate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import me.jscott.Utils;
import me.jscott.geezersunited.Reg;
import flixel.input.mouse.FlxMouseButton;

class Player extends Movable {

    // TODO: We'll need to support actual stats that change by player
    // They can be 1-100
    public var SPEED_STAT = 20;
    public var POWER_STAT = 20;
    public var FLEXIBILITY_STAT = 20;

    var kickingProgress:Float = 0.0;
    var movingTween: FlxTween;

    override public function getSpeed() {
        return SPEED_STAT;
    }

    override public function getPower() {
        return POWER_STAT;
    }

    override public function getFlexibility() {
        return FLEXIBILITY_STAT;
    }

    override public function mousePressed(item:FlxSprite) {
        super.mousePressed(item);

        if (this.movingTween != null) {
            this.movingTween.cancel();
            this.movingTween = null;
        }
    }

	public function new(matchState: MatchState, x: Float, y: Float, color: FlxColor) {
		super(matchState, x, y, color);
		makeGraphic(Reg.PLAYER_WIDTH, Reg.PLAYER_HEIGHT, color);
	}

	override public function update(elapsed:Float) {
        super.update(elapsed);

        if (kickingTo != null && matchState.kicking == null) {

            if (kickingProgress >= calculatePowerTime(kickingTo)) {
                kick(kickingTo);
            } else {
                kickingProgress += elapsed;
            }
        } else if (kickingTo == null && movingTween == null && points.length > 0) {
            var nextPoint = points.shift();
            while (nextPoint.x == x && nextPoint.y == y) {
                if (points.length == 0) {
                    return;
                }
                nextPoint = points.shift();
            }

            movingTween = FlxTween.tween(this, { x: nextPoint.x, y: nextPoint.y }, calculateTravelTime(new FlxPoint(x, y), nextPoint), {onComplete: function(tween:FlxTween) {
                movingTween = null;
            }});
        } else if (movingTween == null && points.length == 0 && kickingTo == null && matchState.moving != this && nextMovable != null && Math.abs(nextMovable.x - x) < 2 && Math.abs(nextMovable.y - y) < 2) {
            // merge the nextMovable
            points = nextMovable.points;
            kickingTo = nextMovable.kickingTo;

            nextMovable.remove(false);
            nextMovable = nextMovable.nextMovable;
            if (nextMovable != null) {
                nextMovable.previousMovable = this;
            }
        }
    }

    override public function recalculateTime() {
        // Calculate and display the amount of time to execute the queued movement

        // First we calculate the total amount of travel time
        var nextPoint = new FlxPoint(x, y);

        if (kickingTo != null) {
            // Kicking
            movementText.text = Std.string(Std.int(calculatePowerTime(kickingTo) - kickingProgress) + 1) + "/" + Std.string(Std.int(calculateBallTravelTime(kickingTo)));
        } else {
            movementText.text = "";
        }

        var travelTime:Float = 0;
        for (point in points) {
            travelTime += calculateTravelTime(nextPoint, point);
            nextPoint = point;
        }
        
        if (travelTime > 0) {
            if (kickingTo != null) {
                 movementText.text += "\n";
            }
            movementText.text += Std.string(Std.int(travelTime) + 1);
        }
    }

    override public function setKickingTo(point:FlxPoint) {
        super.setKickingTo(point);
        kickingProgress = 0.0;
    }

    function kick(point:FlxPoint) {
        // First figure out if we're close enough to the ball to kick it
        if (new FlxPoint(x + Reg.PLAYER_WIDTH / 2, y + Reg.PLAYER_HEIGHT / 2).distanceTo(new FlxPoint(matchState.ball.x + Reg.BALL_WIDTH / 2, matchState.ball.y + Reg.BALL_HEIGHT / 2)) < Reg.BALL_KICK_DISTANCE) {
            matchState.ball.kick(kickingTo, POWER_STAT);
            kickingTo = null;
            kickingProgress = 0.0;
        }
    }
}