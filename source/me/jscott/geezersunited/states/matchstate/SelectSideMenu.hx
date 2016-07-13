package me.jscott.geezersunited.states.matchstate;

import me.jscott.ui.Menu;
import me.jscott.ui.controllers.Controller;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class SelectSideMenu extends Menu {
    var loadedControllerCount = 0;
    var controllerIcons = new Map<Controller, FlxSprite>();
    var controllerPosition = new Map<Controller, Int>();
    var isConfirmed = new Map<Controller, Bool>();

    var matchState:MatchState;
    var defaultController:Controller;

    public function new(matchState:MatchState, defaultController:Controller) {
        super(matchState, matchState);
        this.matchState = matchState;
        this.defaultController = defaultController;
    }

    override public function create():Void {
        _xml_id = "select_side";
        super.create();

        // Now we want to add an icon representing each enabled controller
        for (controller in menuHost.getControllers()) {
            addController(controller);
        }
    }

    public function addController(controller:Controller) {
        controllerPosition.set(controller, 0);
        if (controller == defaultController) {
            controllerPosition.set(controller, -1);
        }

        var sprite = new FlxSprite(0, 0);
        sprite.makeGraphic(100, 100, FlxColor.RED);
        sprite.x = FlxG.width / 2 - sprite.width / 2;
        sprite.y = 220 + loadedControllerCount * (sprite.height + 10);
        _ui.add(sprite);
        controllerIcons.set(controller, sprite);
        loadedControllerCount += 1;

        refreshControllerIcon(controller);
    }

    function checkConfirmed() {
        var atLeastOneController = false;
        var controllers1 = new Array<Controller>();
        var controllers2 = new Array<Controller>();
        for (controller in controllerPosition.keys()) {
            if (controllerPosition[controller] != 0 && !isConfirmed[controller]) {
                return;
            } else if (controllerPosition[controller] != 0) {
                atLeastOneController = true;
                if (controllerPosition[controller] == -1) {
                    controllers1.push(controller);
                } else {
                    controllers2.push(controller);
                }
            }
        }

        if (atLeastOneController) {
            matchState.setControllers(controllers1, controllers2);
            close();
        }
    }

    function refreshControllerIcon(controller:Controller) {
        if (isConfirmed[controller]) {
            controllerIcons[controller].makeGraphic(100, 100, FlxColor.BLUE);
        } else {
            controllerIcons[controller].makeGraphic(100, 100, FlxColor.RED);
        }

        if (controllerPosition[controller] == 0) {
            controllerIcons[controller].x = FlxG.width / 2 - controllerIcons[controller].width / 2;
        } else if (controllerPosition[controller] < 0) {
            controllerIcons[controller].x = 100;
        } else {
            controllerIcons[controller].x = 820;
        }
    }

    public override function pressLeft(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            if (!isConfirmed[controller]) {
                controllerPosition[controller] -= 1;
                if (controllerPosition[controller] < -1) {
                    controllerPosition[controller] = -1;
                }

                refreshControllerIcon(controller);
            }
        }
    }

    public override function pressRight(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            if (!isConfirmed[controller]) {
                controllerPosition[controller] += 1;
                if (controllerPosition[controller] > 1) {
                    controllerPosition[controller] = 1;
                }

                refreshControllerIcon(controller);
            }
        }
    }

    public override function pressA(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            if (controllerPosition[controller] != 0) {
                isConfirmed[controller] = true;
            }

            refreshControllerIcon(controller);
            checkConfirmed();
        }
    }

    public override function pressB(controller:Controller, justPressed:Bool):Void {
        if (justPressed) {
            if (controllerPosition[controller] != 0) {
                isConfirmed[controller] = false;
            }

            refreshControllerIcon(controller);
            checkConfirmed();
        }
    }
}