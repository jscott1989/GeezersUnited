package me.jscott.geezersunited.sides;

import me.jscott.geezersunited.states.matchstate.MatchState;

class AISide extends Side {
    public function new(side:Int, matchState:MatchState) {
        super(side, matchState);
    }

    public override function update(elapsed:Float) {
        for (p in 0...5) {
            controlPlayer(p, elapsed);
        }
    }
}