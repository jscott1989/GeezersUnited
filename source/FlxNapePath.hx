package ;

import flash.display.Graphics;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxPath.FlxPathManager;
import flixel.util.FlxPath;
import flixel.math.FlxAngle;
import flixel.addons.nape.FlxNapeSprite;
import nape.geom.Vec2;

/**
 * This is a simple path data container.  Basically a list of points that
 * a Flx_object can follow.  Also has code for drawing debug visuals.
 * FlxTilemap.findPath() returns a path _object, but you can
 * also just make your own, using the add() functions below
 * or by creating your own array of points.
 */
class FlxNapePath extends FlxPath
{
    public static var manager:FlxPathManager;
    /**
     * Path behavior controls: move from the start of the path to the end then stop.
     */
    public static inline var FORWARD:Int = 0x000000;
    /**
     * Path behavior controls: move from the end of the path to the start then stop.
     */
    public static inline var BACKWARD:Int= 0x000001;
    /**
     * Path behavior controls: move from the start of the path to the end then directly back to the start, and start over.
     */
    public static inline var LOOP_FORWARD:Int = 0x000010;
    /**
     * Path behavior controls: move from the end of the path to the start then directly back to the end, and start over.
     */
    public static inline var LOOP_BACKWARD:Int = 0x000100;
    /**
     * Path behavior controls: move from the start of the path to the end then turn around and go back to the start, over and over.
     */
    public static inline var YOYO:Int = 0x001000;
    /**
     * Path behavior controls: ignores any vertical component to the path data, only follows side to side.
     */
    public static inline var HORIZONTAL_ONLY:Int = 0x010000;
    /**
     * Path behavior controls: ignores any horizontal component to the path data, only follows up and down.
     */
    public static inline var VERTICAL_ONLY:Int = 0x100000;

    /**
     * Internal helper for keeping new variable instantiations under control.
     */
    private static var _point:FlxPoint = FlxPoint.get();

  public var _object:FlxNapeSprite;

    /**
     * Creates a new FlxPath (and calls start() right away if _object != null).
     */
  public function new(?Object:FlxNapeSprite, ?Nodes:Array<FlxPoint>, Speed:Float = 100, Mode:Int = FlxPath.FORWARD, AutoRotate:Bool = false)
  {
    super();
    //  if (_object != null)
    //  {
    //    start(_object, Nodes, Speed, Mode, AutoRotate);
    //  }
  }

  public function start2(Object:FlxNapeSprite, Nodes:Array<FlxPoint>, Speed:Float = 100, Mode:Int = FlxPath.FORWARD, AutoRotate:Bool = false):FlxPath
  {

    _object = Object;
    nodes = Nodes;
    speed = Math.abs(Speed);
    _mode = Mode;
    _autoRotate = AutoRotate;
    restart();

    return this;
  }

    override public function restart():FlxPath
    {
        if (manager != null && !_inManager)
        {
            manager.add(this);
            _inManager = true;
        }

        finished = false;
        active = true;
        if (nodes.length <= 0)
        {
            active = false;
        }

        //get starting node
        if ((_mode == FlxPath.BACKWARD) || (_mode == FlxPath.LOOP_BACKWARD))
        {
            _nodeIndex = nodes.length - 1;
            _inc = -1;
        }
        else
        {
            _nodeIndex = 0;
            _inc = 1;
        }

        _object.immovable = true;

        return this;
    }


    /**
     * Internal function for moving the _object along the path.
     * Generally this function is called automatically by preUpdate().
     * The first half of the function decides if the _object can advance to the next node in the path,
     * while the second half handles actually picking a velocity toward the next node.
     */
   override public function update():Void
    {

        //first check if we need to be pointing at the next node yet
        _point.x = _object.x;
        _point.y = _object.y;
        if (autoCenter)
        {
            _point.x += _object.width * 0.5;
            _point.y += _object.height * 0.5;
        }
        var node:FlxPoint = nodes[_nodeIndex];
        var deltaX:Float = node.x - _point.x;
        var deltaY:Float = node.y - _point.y;

        var horizontalOnly:Bool = (_mode & FlxPath.HORIZONTAL_ONLY) > 0;
        var verticalOnly:Bool = (_mode & FlxPath.VERTICAL_ONLY) > 0;

        if (horizontalOnly)
        {
            if (((deltaX > 0) ? deltaX : -deltaX) < speed * FlxG.elapsed)
            {
                node = advancePath();
            }
        }
        else if (verticalOnly)
        {
            if (((deltaY > 0) ? deltaY : -deltaY) < speed * FlxG.elapsed)
            {
                node = advancePath();
            }
        }
        else
        {
            if (Math.sqrt(deltaX * deltaX + deltaY * deltaY) < speed * FlxG.elapsed)
            {
                node = advancePath();
            }
        }

        //then just move toward the current node at the requested speed
        if (speed != 0)
        {
            //set velocity based on path mode
            _point.x = _object.x;
            _point.y = _object.y;

            if (autoCenter)
            {
                _point.x += _object.width * 0.5;
                _point.y += _object.height * 0.5;
            }

            if (horizontalOnly || (_point.y == node.y))
            {
                _object.body.velocity.x = (_point.x < node.x) ? speed : -speed;
                if (_object.body.velocity.x < 0)
                {
                    angle = -90;
                }
                else
                {
                    angle = 90;
                }
                if (!horizontalOnly)
                {
                    _object.body.velocity.y = 0;
                }
            }
            else if (verticalOnly || (_point.x == node.x))
            {
                _object.body.velocity.y = (_point.y < node.y) ? speed : -speed;
                if (_object.body.velocity.y < 0)
                {
                    angle = 0;
                }
                else
                {
                    angle = 180;
                }
                if (!verticalOnly)
                {
                    _object.body.velocity.x = 0;
                }
            }
            else
            {
                _object.body.velocity.x = (_point.x < node.x) ? speed : -speed;
                _object.body.velocity.y = (_point.y < node.y) ? speed : -speed;
                angle = FlxAngle.getAngle(_point, node);
                var v = FlxAngle.rotatePoint(0, speed, 0, 0, angle, FlxPoint.get( _object.body.velocity.x, _object.body.velocity.y) );
        _object.body.velocity.x = v.x;
        _object.body.velocity.y = v.y;
            }

            //then set _object rotation if necessary
            if (_autoRotate)
            {
        _object.angularVelocity = 0;
                _object.body.angularVel = 0;
        _object.body.kinAngVel = 0;
                _object.angularAcceleration = 0;
                _object.angle = angle;
        _object.body.rotation = angle * FlxAngle.TO_RAD;

            }

            if (finished)
            {
                cancel();
            }
        }
    }

    /**
     * Internal function that decides what node in the path to aim for next based on the behavior flags.
     *
     * @return  The node (a FlxPoint _object) we are aiming for next.
     */
   override private function advancePath(Snap:Bool = true):FlxPoint
    {
        if (Snap)
        {
            var oldNode:FlxPoint = nodes[_nodeIndex];
            if (oldNode != null)
            {
                if ((_mode & FlxPath.VERTICAL_ONLY) == 0)
                {
                    _object.x = oldNode.x;
          _object.body.position.x = _object.x;
                    if (autoCenter)
                        _object.x -= _object.width * 0.5;
                }
                if ((_mode & FlxPath.HORIZONTAL_ONLY) == 0)
                {
                    _object.y = oldNode.y;
          _object.body.position.y = _object.y;
                    if (autoCenter)
                        _object.y -= _object.height * 0.5;
                }
            }
        }

        var callComplete:Bool = false;
        _nodeIndex += _inc;

        if ((_mode & FlxPath.BACKWARD) > 0)
        {
            if (_nodeIndex < 0)
            {
                _nodeIndex = 0;
                finished = callComplete = true;
            }
        }
        else if ((_mode & FlxPath.LOOP_FORWARD) > 0)
        {
            if (_nodeIndex >= nodes.length)
            {
                callComplete = true;
                _nodeIndex = 0;
            }
        }
        else if ((_mode & FlxPath.LOOP_BACKWARD) > 0)
        {
            if (_nodeIndex < 0)
            {
                _nodeIndex = nodes.length - 1;
                callComplete = true;
                if (_nodeIndex < 0)
                {
                    _nodeIndex = 0;
                }
            }
        }
        else if ((_mode & FlxPath.YOYO) > 0)
        {
            if (_inc > 0)
            {
                if (_nodeIndex >= nodes.length)
                {
                    _nodeIndex = nodes.length - 2;
                    callComplete = true;
                    if (_nodeIndex < 0)
                    {
                        _nodeIndex = 0;
                    }
                    _inc = -_inc;
                }
            }
            else if (_nodeIndex < 0)
            {
                _nodeIndex = 1;
                callComplete = true;
                if (_nodeIndex >= nodes.length)
                {
                    _nodeIndex = nodes.length - 1;
                }
                if (_nodeIndex < 0)
                {
                    _nodeIndex = 0;
                }
                _inc = -_inc;
            }
        }
        else
        {
            if (_nodeIndex >= nodes.length)
            {
                _nodeIndex = nodes.length - 1;
                finished = callComplete = true;
            }
        }

        if (callComplete && onComplete != null)
        {
            onComplete(this);
        }

        return nodes[_nodeIndex];
    }

    /**
     * Stops path movement and removes this path it from the path manager.
     */
   override public function cancel():Void
    {
        finished = true;

        if (_object != null)
        {
            _object.body.velocity.setxy(0, 0);
        }

        if (manager != null && _inManager)
        {
            manager.remove(this);
            _inManager = false;
        }
    }

}