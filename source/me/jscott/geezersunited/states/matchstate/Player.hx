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
    var num = 0;
    public function new(num:Int, x: Float, y: Float) {
        this.num = num;
        super(x, y);
        
        makeGraphic(Reg.PLAYER_WIDTH, Reg.PLAYER_HEIGHT, FlxColor.TRANSPARENT, true);
        drawSprite();
        createCircularBody(Reg.BALL_WIDTH / 2);
        body.space = FlxNapeSpace.space;
    }

    function drawSprite() {

        var c = FlxColor.ORANGE;
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
    }

    var highlightColor: FlxColor;

    public function setHighlighted(color:FlxColor) {
        this.highlightColor = color;
        drawSprite();
    }
}