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


/**
 * This represents a future position of a player, and can be clicked to extend the
 * current run path or to prepare a kick once the run has completed.
 */
class PlayerEndMovement extends Movable {

    public function new(matchState: MatchState, x: Float, y: Float, color: FlxColor, previousMovable) {
        super(matchState, x, y, color, previousMovable);
        makeGraphic(Reg.PLAYER_WIDTH, Reg.PLAYER_HEIGHT, color);
        alpha = 0.5;
	}

    override public function getSpeed() {
        return previousMovable.getSpeed();
    }

    override public function getPower() {
        return previousMovable.getPower();
    }

    override public function getFlexibility() {
        return previousMovable.getFlexibility();
    }
}