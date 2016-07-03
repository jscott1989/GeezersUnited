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

class Movable extends FlxSprite {

    public var points = new Array<FlxPoint>();
    public var kickingTo:FlxPoint;

    var matchState: MatchState;
    var movementText = new FlxText(0, 0, Reg.PLAYER_WIDTH, "", 15);

    public var nextMovable:Movable;
    public var previousMovable:Movable;
    var teamColor:FlxColor;

    public function remove(cascade = true) {
        matchState.remove(this);
        matchState.remove(movementText);
        FlxMouseEventManager.remove(this);
        if (cascade) {
            if (nextMovable != null) {
                nextMovable.remove();
            }
        }
    }

    public function mousePressed(item:FlxSprite) {
        var xOffset = FlxG.mouse.x - this.x;
        var yOffset = FlxG.mouse.y - this.y;

        if (nextMovable != null) {
            nextMovable.remove();
            nextMovable = null;
        }

        if (FlxG.mouse.pressed) {
            // Left button, start moving
            matchState.startMoving(this, xOffset, yOffset);
            this.points = new Array<FlxPoint>();
        } else {
            // Right button, start kicking
            this.kickingTo = null;
            matchState.startKicking(this, xOffset, yOffset);
        }
    }

	public function new(matchState: MatchState, x: Float, y: Float, color: FlxColor, previousMovable:Movable = null) {
		super(x, y);
        this.matchState = matchState;
        this.previousMovable = previousMovable;
        teamColor = color;
        
		FlxMouseEventManager.add(this, mousePressed, null, null, null, false, true, true, [FlxMouseButtonID.LEFT, FlxMouseButtonID.RIGHT]);

        movementText.alignment = "center";
        matchState.add(movementText);
	}

    public function getSpeed() {
        return 0;
    }

    public function getPower() {
        return 0;
    }

    public function getFlexibility() {
        return 0;
    }

    public function calculateTravelTime(source:FlxPoint, target:FlxPoint) {
        var distance = source.distanceTo(target);
        var distanceNormalized = distance * 0.03; // MAGIC NUMBER
        return distanceNormalized * ((100 - getSpeed()) / 100);
    }

	override public function update(elapsed:Float) {
        recalculateTime();

        movementText.x = x;
        movementText.y = y + (Reg.PLAYER_HEIGHT / 2) - (movementText.height / 2);
        Utils.bringToFront(matchState.members, movementText, this);


        // Remove kicking if we're not actually kicking any distance
        if (kickingTo != null && Math.abs(kickingTo.x - x) < 10 && Math.abs(kickingTo.y - y)  < 10) {
            kickingTo = null;
        }
    }

    /**
     * Add a position for this player to run to
     */
    public function addPoint(point:FlxPoint) {
        points.push(point);

        if (nextMovable == null) {
            nextMovable = new PlayerEndMovement(matchState, 0, 0, teamColor, this);
            matchState.add(nextMovable);
        }

        nextMovable.x = point.x;
        nextMovable.y = point.y;
    }

    function calculatePowerTime(point:FlxPoint) {
        // Calculate the time
        // Bigger distance + Bigger power = longer
        // Bigger flexibility = shorter
        var distance = new FlxPoint(x, y).distanceTo(kickingTo);
        var distanceNormalized = distance * 0.03; // MAGIC NUMBER
        return distanceNormalized * (getPower()/100) * (1.0 - (getFlexibility() / 100));
    }

    function calculateBallTravelTime(point:FlxPoint) {
        // Calculate the time the ball will take to reach the target
        return matchState.ball.calculateTravelTime(new FlxPoint(x, y), kickingTo, getPower());
    }

    public function recalculateTime() {
        // Calculate and display the amount of time to execute the queued movement

        // First we calculate the total amount of travel time
        var nextPoint = new FlxPoint(x, y);

        if (kickingTo != null) {
            // Kicking
            movementText.text = Std.string(Std.int(calculatePowerTime(kickingTo)) + 1) + "/" + Std.string(Std.int(calculateBallTravelTime(kickingTo))) + "\n";
        } else {
            movementText.text = "";
        }

        var travelTime:Float = 0;
        for (point in points) {
            travelTime += calculateTravelTime(nextPoint, point);
            nextPoint = point;
        }
        
        if (travelTime > 0) {
            movementText.text += Std.string(Std.int(travelTime) + 1);
        }
    }

    public function setKickingTo(point:FlxPoint) {
        kickingTo = point;
        if (Math.abs(kickingTo.x - x) > 10 || Math.abs(kickingTo.y - y) > 10) {
            this.points = new Array<FlxPoint>();
        }
    }
}