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
        // Turn so that we're looking towards the ball
        var player = matchState.players[side][playerI];

        var angleToBall = new FlxPoint(player.body.position.x, player.body.position.y).angleBetween(new FlxPoint(matchState.ball.body.position.x, matchState.ball.body.position.y));
        player.turnTowards(angleToBall, elapsed);
    }
}