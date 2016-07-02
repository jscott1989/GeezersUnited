package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import me.jscott.geezersunited.Reg;
import me.jscott.Utils;
import flixel.text.FlxText;
import flixel.FlxG;

class Player extends FlxSprite {

    // TODO: We'll need to support actual stats that change by player
    // They can be 1-100
    public var SPEED_STAT = 20;

    var matchState: MatchState;
    var movingTween: FlxTween;

    var movementText = new FlxText(100, 100, "", 40);

	public function new(matchState: MatchState, x: Float, y: Float, color: FlxColor) {
		super(x, y);
        this.matchState = matchState;
		makeGraphic(Reg.PLAYER_WIDTH, Reg.PLAYER_HEIGHT, color);

		// TODO: This needs to support right mouse presses too...
		FlxMouseEventManager.add(this, function(item:FlxSprite) {
            var xOffset = FlxG.mouse.x - this.x;
            var yOffset = FlxG.mouse.y - this.y;
            matchState.startMoving(this, xOffset, yOffset);
        });

        matchState.add(movementText);
	}

    public function calculateTravelTime(source:FlxPoint, target:FlxPoint) {
        var distance = source.distanceTo(target);
        var distanceNormalized = distance * 0.03; // MAGIC NUMBER
        return distanceNormalized * ((100 - SPEED_STAT) / 100);
    }

    public function move() {
        if (movingTween == null && points.length > 0) {
            var nextPoint = points.shift();
            while (nextPoint.x == x && nextPoint.y == y) {
                if (points.length == 0) {
                    return;
                }
                nextPoint = points.shift();
            }

            movingTween = FlxTween.tween(this, { x: nextPoint.x, y: nextPoint.y }, calculateTravelTime(new FlxPoint(x, y), nextPoint), {onComplete: function(tween:FlxTween) {
                movingTween = null;
                move();
            }});
        }
    }

	override public function update(elapsed:Float) {
        recalculateTime();

        movementText.x = x;
        movementText.y = y;
        Utils.bringToFront(matchState.members, movementText, this);
    }

    var points = new Array<FlxPoint>();
    /**
     * Add a position for this player to run to
     */
    public function addPoint(point:FlxPoint) {
        points.push(point);
        move();
    }

    public function recalculateTime() {
        // Calculate and display the amount of time to execute the queued movement

        // First we calculate the total amount of travel time
        var nextPoint = new FlxPoint(x, y);
        var travelTime:Float = 0;
        for (point in points) {
            travelTime += calculateTravelTime(nextPoint, point);
            nextPoint = point;
        }
        if (travelTime == 0) {
            movementText.text = "";
        } else {
            movementText.text = Std.string(Std.int(travelTime) + 1);
        }
    }
}