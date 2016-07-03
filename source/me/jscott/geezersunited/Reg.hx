package me.jscott.geezersunited;

/**
 * Cross-state storage.
 **/
class Reg {

    // Constants
    public static var PLAYER_WIDTH = 64;
    public static var PLAYER_HEIGHT = 64;

    public static var BALL_WIDTH = 32;
    public static var BALL_HEIGHT = 32;

    // Standard Football Pitch dimensions are roughly 5/2 I think
    public static var PITCH_WIDTH = 800;
    public static var PITCH_HEIGHT = Std.int(PITCH_WIDTH * (2/5));

    public static var GOAL_WIDTH = 32;
    public static var GOAL_HEIGHT = Std.int(PITCH_HEIGHT * 0.5);


    public static var BALL_KICK_DISTANCE = 64;
}