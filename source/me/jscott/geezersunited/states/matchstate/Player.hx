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

class Player extends FlxSprite {

    // TODO: We'll need to support actual stats that change by player
    // They can be 1-100
    public var SPEED_STAT = 20;
    public var POWER_STAT = 20;
    public var FLEXIBILITY_STAT = 20;

    public var points = new Array<FlxPoint>();
    public var kickingTo:FlxPoint;


    var kickingProgress:Float = 0.0;

    var matchState: MatchState;
    var movingTween: FlxTween;

    var movementText = new FlxText(0, 0, Reg.PLAYER_WIDTH, "", 15);

	public function new(matchState: MatchState, x: Float, y: Float, color: FlxColor) {
		super(x, y);
        this.matchState = matchState;
		makeGraphic(Reg.PLAYER_WIDTH, Reg.PLAYER_HEIGHT, color);

		// TODO: This needs to support right mouse presses too...
		FlxMouseEventManager.add(this, function(item:FlxSprite) {
            var xOffset = FlxG.mouse.x - this.x;
            var yOffset = FlxG.mouse.y - this.y;
            this.kickingTo = null;
            this.points = new Array<FlxPoint>();
            if (this.movingTween != null) {
                this.movingTween.cancel();
                this.movingTween = null;
            }
            if (FlxG.mouse.pressed) {
                // Left button, start moving
                matchState.startMoving(this, xOffset, yOffset);
            } else {
                // Right button, start kicking
                matchState.startKicking(this, xOffset, yOffset);
            }
        },null, null, null, false, true, true, [FlxMouseButtonID.LEFT, FlxMouseButtonID.RIGHT]);

        movementText.alignment = "center";
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
        movementText.y = y + (Reg.PLAYER_HEIGHT / 2) - (movementText.height / 2);
        Utils.bringToFront(matchState.members, movementText, this);


        if (kickingTo != null) {
            kickingProgress += elapsed;

            if (kickingProgress >= calculatePowerTime(kickingTo)) {
                kick(kickingTo);
            }
        }
    }

    /**
     * Add a position for this player to run to
     */
    public function addPoint(point:FlxPoint) {
        points.push(point);
        move();
    }

    function calculatePowerTime(point:FlxPoint) {
        // Calculate the time
        // Bigger distance + Bigger power = longer
        // Bigger flexibility = shorter
        var distance = new FlxPoint(x, y).distanceTo(kickingTo);
        var distanceNormalized = distance * 0.03; // MAGIC NUMBER
        return distanceNormalized * (POWER_STAT/100) * (1.0 - (FLEXIBILITY_STAT / 100));
    }

    function calculateBallTravelTime(point:FlxPoint) {
        // Calculate the time the ball will take to reach the target
        return 2.0;
    }

    public function recalculateTime() {
        // Calculate and display the amount of time to execute the queued movement

        // First we calculate the total amount of travel time
        var nextPoint = new FlxPoint(x, y);

        if (kickingTo != null) {
            // Kicking
            movementText.text = Std.string(Std.int(calculatePowerTime(kickingTo) - kickingProgress) + 1) + "/" + Std.string(Std.int(calculateBallTravelTime(kickingTo)));
        } else {
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

    public function setKickingTo(point:FlxPoint) {
        kickingTo = point;
        kickingProgress = 0.0;
    }

    function kick(point:FlxPoint) {
        kickingTo = null;
        kickingProgress = 0.0;
    }
}