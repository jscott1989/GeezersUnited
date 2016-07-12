package me.jscott;

/**
 * Cross-state storage.
 **/
class Configuration {

    // Constants
    public static inline var PLAYER_WIDTH = 64;
    public static inline var PLAYER_HEIGHT = 64;

    public static inline var BALL_WIDTH = 32;

    // Standard Football Pitch dimensions are roughly 5/2 I think
    public static inline var PITCH_WIDTH = 800;
    public static inline var PITCH_HEIGHT = Std.int(PITCH_WIDTH * (2/5));

    public static inline var ROTATION_SPEED = 100;
    public static inline var TRAVEL_SPEED = 100;
    public static inline var KICK_SPEED = 500;
    public static inline var KICK_DISTANCE = 64;

    public static inline var HOLD_REPEAT_TIMEOUT = 0.5;
}