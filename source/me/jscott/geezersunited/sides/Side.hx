package me.jscott.geezersunited.sides;

import me.jscott.geezersunited.states.matchstate.MatchState;
import flixel.math.FlxPoint;

/**
 * This represents the controllers of a team in a match
 * This can either be AI or Human
 */
class Side {
    var side:Int;
    var matchState:MatchState;
    private function new(side:Int, matchState:MatchState) {
        this.side = side;
        this.matchState = matchState;
    }

    public function resetState() {
        
    }

    public function update(elapsed:Float) {
        
    }

    function controlPlayer(playerI:Int, elapsed:Float) {

        // Move to ensure that we're 50% between the ball's position and our "natural" position
        var player = matchState.players[side][playerI];

        var targetPosition = new FlxPoint(player.formationPosition.x, player.formationPosition.y);
        var ballPosition = new FlxPoint(matchState.ball.body.position.x, matchState.ball.body.position.y);
        var targetAngle = Utils.normaliseAngle(targetPosition.angleBetween(ballPosition));

        // targetPosition.y -= Math.cos(targetAngle) * 10;
        // targetPosition.x += Math.sin(targetAngle) * 10;

        player.moveToPoint(targetPosition, targetAngle, elapsed);
    }
}