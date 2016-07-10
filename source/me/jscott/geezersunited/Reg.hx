package me.jscott.geezersunited;

/**
 * Cross-state storage.
 **/
class Reg {

    // Constants
    public static var PLAYER_WIDTH = 64;
    public static var PLAYER_HEIGHT = 64;

    public static var BALL_WIDTH = 32;

    // Standard Football Pitch dimensions are roughly 5/2 I think
    public static var PITCH_WIDTH = 800;
    public static var PITCH_HEIGHT = Std.int(PITCH_WIDTH * (2/5));

    public static var ROTATION_SPEED = 5;
    public static var TRAVEL_SPEED = 2;
    public static var KICK_SPEED = 500;
    public static var KICK_DISTANCE = 64;
}