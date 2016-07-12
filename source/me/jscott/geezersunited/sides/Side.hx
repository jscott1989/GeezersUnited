package me.jscott.geezersunited.sides;

import me.jscott.Utils;
import me.jscott.geezersunited.states.matchstate.MatchState;
import me.jscott.geezersunited.states.matchstate.Player;
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
        var ballPosition = new FlxPoint(matchState.ball.body.position.x, matchState.ball.body.position.y);

        if (player.role == Player.GK) {
            var targetPosition = new FlxPoint(player.formationPosition.x, player.formationPosition.y);
            targetPosition.y = ballPosition.y;
            var targetAngle = Utils.normaliseAngle(targetPosition.angleBetween(ballPosition));
            player.moveToPoint(targetPosition, targetAngle, elapsed);

        } else {
            
        }

        // targetPosition.x = (targetPosition.x + ballPosition.x) / 2;
        // targetPosition.y = (targetPosition.y + ballPosition.y) / 2;

    }
}