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

	override public function update(elapsed:Float) {
		this.fill(FlxColor.TRANSPARENT);
		for (player in matchState.players) {
			var nextPoint = new FlxPoint(player.x, player.y);
	        for (point in player.points) {
	            this.drawLine(nextPoint.x - this.x + Reg.PLAYER_WIDTH / 2, nextPoint.y - this.y + Reg.PLAYER_HEIGHT / 2, point.x - this.x + Reg.PLAYER_WIDTH / 2, point.y - this.y + Reg.PLAYER_HEIGHT / 2);
	            nextPoint = point;
	        }
		}
    }
}