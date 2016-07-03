package me.jscott.geezersunited.states.matchstate;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import me.jscott.geezersunited.Reg;
import flixel.math.FlxPoint;
using flixel.util.FlxSpriteUtil;

class TacticsOverlay extends FlxSprite {
	var matchState: MatchState;

	public function new(matchState: MatchState, x: Float, y: Float) {
		this.matchState = matchState;
		super(x, y);
		makeGraphic(Reg.PITCH_WIDTH, Reg.PITCH_HEIGHT, FlxColor.TRANSPARENT);
	}

	function drawFromMovable(movable:Movable) {
		// Draw Movement
		var nextPoint = new FlxPoint(movable.x, movable.y);
        for (point in movable.points) {
            this.drawLine(nextPoint.x - this.x + Reg.PLAYER_WIDTH / 2, nextPoint.y - this.y + Reg.PLAYER_HEIGHT / 2, point.x - this.x + Reg.PLAYER_WIDTH / 2, point.y - this.y + Reg.PLAYER_HEIGHT / 2);
            nextPoint = point;
        }

        // Draw kicking
        if (movable.kickingTo != null) {
        	this.drawLine(movable.x - this.x + Reg.PLAYER_WIDTH / 2, movable.y - this.y + Reg.PLAYER_HEIGHT / 2, movable.kickingTo.x - this.x + Reg.PLAYER_WIDTH / 2, movable.kickingTo.y - this.y + Reg.PLAYER_HEIGHT / 2, { color: FlxColor.RED, thickness: 3 });
        }

        if (movable.nextMovable != null) {
        	drawFromMovable(movable.nextMovable);
        }
	}

	override public function update(elapsed:Float) {
		this.fill(FlxColor.TRANSPARENT);
		for (player in matchState.players) {
			drawFromMovable(player);
		}
    }
}