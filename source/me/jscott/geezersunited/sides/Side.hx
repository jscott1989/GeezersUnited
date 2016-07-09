package me.jscott.geezersunited.sides;

import me.jscott.geezersunited.states.matchstate.MatchState;

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

    public function update(elapsed:Float) {
        
    }
}