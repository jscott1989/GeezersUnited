// createRectangularBody(30, 30);
// setBodyMaterial(0.5, 0.5, 0.5, 2);
// body.space = FlxNapeSpace.space;
// physicsEnabled = true;

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

class Wall extends FlxNapeSprite {
    public function new(x: Float, y: Float, w:Int, h:Int) {
        x += w / 2;
        y += h / 2;

        super(x, y);
        makeGraphic(w, h, FlxColor.ORANGE);
        createRectangularBody(w, h, BodyType.KINEMATIC);
        // setBodyMaterial(0, 0, 0, 2);
        body.space = FlxNapeSpace.space;
        // physicsEnabled = true;
    }
}