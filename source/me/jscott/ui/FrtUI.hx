package me.jscott.ui;

import flash.errors.Error;
import flixel.FlxG;
import flixel.addons.ui.BorderDef;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIGroup;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIRegion;
import flixel.addons.ui.U;
import flixel.addons.ui.interfaces.IEventGetter;
import flixel.addons.ui.interfaces.IFireTongue;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.addons.ui.interfaces.IHasParams;
import flixel.addons.ui.interfaces.IResizable;
import haxe.xml.Fast;

/**
 * This extends FlxUI and just allows us to set "Screen" for a two player game
 */
class FrtUI extends FlxUI {

    var menuHost:MenuHost;

    public function new(menuHost:MenuHost, data:Fast = null, ptr:IEventGetter = null, superIndex_:FlxUI = null, tongue_:IFireTongue = null, liveFilePath_:String="", uiVars_:Map<String,String>=null) {
        this.menuHost = menuHost;
        super(data, ptr, superIndex_, tongue_, liveFilePath_, uiVars_);
    }


    /**
     * Main setup function - pass in a Fast(xml) object 
     * to set up your FlxUI
     * @param   data

     * This has just been changed so that screen.width is correct for 2 players
     */
    
    @:access(Xml)
    public override function load(data:Fast):Void
    {
        _group_index = new Map<String,FlxUIGroup>();
        _asset_index = new Map<String,IFlxUIWidget>();
        _tag_index = new Map<String,Array<String>>();
        _definition_index = new Map<String,Fast>();
        if (_variable_index == null)
        {
            _variable_index = new Map<String,String>();
        }
        _mode_index = new Map<String,Fast>();
        
        if (data != null)
        {
            if (_superIndexUI == null)
            {
                //add a widget to represent the screen so you can do "screen.width", etc
                var screenRegion = new FlxUIRegion(0, 0, FlxG.width, FlxG.height);
                
                if (menuHost.isSplitScreen()) {
                    screenRegion.width = FlxG.width / 2;
                }

                screenRegion.name = "screen";
                addAsset(screenRegion, "screen");

                var midPointRegion = new FlxUIRegion(FlxG.width/2, FlxG.height/2, FlxG.width/2, FlxG.height/2);
                if (menuHost.isSplitScreen()) {
                    midPointRegion.x = FlxG.width / 4;
                    midPointRegion.width = FlxG.width / 4;
                }

                midPointRegion.name = "midpoint";
                addAsset(midPointRegion, "midpoint");
            }
            
            _data = data;
            
            
            if (data.hasNode.inject)
            {
                while(data.hasNode.inject)
                {
                    var inj_data = data.node.inject;
                    var inj_name:String = U.xml_name(inj_data.x);
                    var payload:Xml = U.xml(inj_name, "xml", false);
                    if (payload != null)
                    {
                        var parent = inj_data.x.parent;
                        var i:Int = 0;
                        for (child in parent.children)
                        {
                            if (child == inj_data.x)
                            {
                                break;
                            }
                            i++;
                        }
                        
                        if (parent.removeChild(inj_data.x))
                        {
                            var j:Int = 0;
                            for (e in payload.elements())
                            {
                                parent.insertChild(e, i + j);
                                j++;
                            }
                        }
                    }
                }
            }
            
            //See if there's anything to include
            if (data.hasNode.include)
            {
                for (inc_data in data.nodes.include)
                {
                    var inc_name:String = U.xml_name(inc_data.x);
                    
                    var liveFile:Fast = null;
                    
                    #if (debug && sys)
                        if (liveFilePath != null && liveFilePath != "")
                        {
                            try
                            {
                                liveFile = U.readFast(U.fixSlash(liveFilePath + inc_name + ".xml"));
                            }
                            catch (msg:String)
                            {
                                FlxG.log.warn(msg);
                                liveFile = null;
                            }
                        }
                    #end
                    
                    var inc_xml:Fast = null;
                    if (liveFile == null)
                    {
                        inc_xml = U.xml(inc_name);
                    }
                    else
                    {
                        inc_xml = liveFile;
                    }
                    
                    if (inc_xml != null)
                    {
                        for (def_data in inc_xml.nodes.definition)
                        {
                            //add a prefix to avoid collisions:
                            var def_name:String = "include:" + U.xml_name(def_data.x);
                            
                            unparentXML(def_data);
                            
                            _definition_index.set(def_name, def_data);
                            //DON'T recursively search for further includes. 
                            //Search 1 level deep only!
                            //Ignore everything else in the include file
                        }
                        
                        if (inc_xml.hasNode.point_size)
                        {
                            _loadPointSize(inc_xml);
                        }
                        
                        if (inc_xml.hasNode.resolve("default"))
                        {
                            for (defaultNode in inc_xml.nodes.resolve("default"))
                            {
                                if (_loadTest(defaultNode))
                                {
                                    var defaultName:String = U.xml_name(defaultNode.x);
                                    
                                    unparentXML(defaultNode);
                                    
                                    _definition_index.set("default:" + defaultName, defaultNode);
                                }
                            }
                        }
                    }
                }
            }
            
            //First, see if we defined a point size
            
            if (data.hasNode.point_size)
            {
                _loadPointSize(data);
            }
            
            //Then, load all our definitions
            if (data.hasNode.definition)
            {
                for (def_data in data.nodes.definition)
                {
                    if (_loadTest(def_data))
                    {
                        var def_name:String = U.xml_name(def_data.x);
                        var error = "";
                        if (def_name.indexOf("default:") != -1)
                        {
                            error = "'default:'";
                        }
                        if (def_name.indexOf("include:") != -1)
                        {
                            error = "'include:'";
                        }
                        if (error != "")
                        {
                            FlxG.log.warn("Can't create FlxUI definition '" + def_name + "', because '" + error + "' is a reserved name prefix!");
                        }
                        else
                        {
                            unparentXML(def_data);
                            
                            _definition_index.set(def_name, def_data);
                        }
                    }
                }
            }
            
            if (data.hasNode.resolve("default"))
            {
                for (defaultNode in data.nodes.resolve("default"))
                {
                    if (_loadTest(defaultNode))
                    {
                        var defaultName:String = U.xml_name(defaultNode.x);
                        
                        unparentXML(defaultNode);
                        
                        _definition_index.set("default:" + defaultName, defaultNode);
                    }
                }
            }
        
            //Next, load all our variables
            if (data.hasNode.variable)
            {
                for (var_data in data.nodes.variable)
                {
                    if (_loadTest(var_data))
                    {
                        var var_name:String = U.xml_name(var_data.x);
                        var var_value = U.xml_str(var_data.x, "value");
                        if (var_name != "")
                        {
                            _variable_index.set(var_name, var_value);
                        }
                    }
                }
            }
        
            //Next, load all our modes
            if (data.hasNode.mode)
            {
                for (mode_data in data.nodes.mode)
                {
                    if (_loadTest(mode_data))
                    {
                        var mode_data2:Fast = applyNodeConditionals(mode_data);
                        var mode_name:String = U.xml_name(mode_data.x);
                        //mode_data
                        
                        unparentXML(mode_data2);
                        
                        _mode_index.set(mode_name, mode_data2);
                    }
                }
            }
            
            //Then, load all our group definitions
            if (data.hasNode.group)
            {
                for (group_data in data.nodes.group)
                {
                    if (_loadTest(group_data))
                    {
                        //Create FlxUIGroup's for each group we define
                        var name:String = U.xml_name(group_data.x);
                        var custom:String = U.xml_str(group_data.x, "custom");
                        
                        var tempGroup:FlxUIGroup = null;
                        
                        //Allow the user to provide their own customized FlxUIGroup class
                        if (custom != "")
                        {
                            var result = _ptr.getRequest("ui_get_group:", this, custom);
                            if (result != null && Std.is(result, FlxUIGroup))
                            {
                                tempGroup = cast result;
                            }
                        }
                        
                        if(tempGroup == null)
                        {
                            tempGroup = new FlxUIGroup();
                        }
                        
                        tempGroup.name = name;
                        _group_index.set(name, tempGroup);
                        add(tempGroup);
                    }
                }
            }
            
            if (data.x.firstElement() != null)
            {
                //Load the actual things
                var node:Xml;
                for (node in data.x.elements()) 
                {
                    _loadSub(node);
                }
            }
            
            _postLoad(data);
            
        }
        else {
            _onFinishLoad();
        }
    }

    // This just uses a FrtUIInputText instead
    private override function _loadInputText(data:Fast):IFlxUIWidget {


        var text:String = U.xml_str(data.x, "text");
        var context:String = U.xml_str(data.x, "context", true, "ui");
        var code:String = U.xml_str(data.x, "code", true, "");
        text = getText(text,context, true, code);
        
        var W:Int = Std.int(_loadWidth(data, 100));
        var H:Int = Std.int(_loadHeight(data, -1));
        
        var the_font:String = _loadFontFace(data);
        
        var align:String = U.xml_str(data.x, "align"); if (align == "") { align = null;}
        var size:Int = Std.int(_loadHeight(data, 8, "size"));
        var color:Int = _loadColor(data);
        
        var border:BorderDef = _loadBorder(data);
        
        var backgroundColor:Int = U.parseHex(U.xml_str(data.x, "background", true, "0x00000000"), true, true, 0x00000000);
        var passwordMode:Bool = U.xml_bool(data.x, "password_mode");
        
        var ft:IFlxUIWidget;
        var fti:FlxUIInputText = new FrtUIInputText(0, 0, W, text, size, color, backgroundColor);
        fti.passwordMode = passwordMode;
            
        var force_case:String = U.xml_str(data.x, "force_case", true, "");
        var forceCase:Int;
        switch(force_case)
        {
            case "upper", "upper_case", "uppercase": forceCase = FlxInputText.UPPER_CASE;
            case "lower", "lower_case", "lowercase": forceCase = FlxInputText.LOWER_CASE;
            case "u", "l":
                    throw new Error("FlxUI._loadInputText(): 1 letter values have been deprecated (force_case attribute).");
            default: forceCase = FlxInputText.ALL_CASES;
        }
        
        var filter:String = U.xml_str(data.x, "filter", true, "");
        var filterMode:Int;
        while (filter.indexOf("_") != -1)
        {
            filter = StringTools.replace(filter, "_", "");  //strip out any underscores
        }
        
        switch(filter)
        {
            case "alpha", "onlyalpha": filterMode = FlxInputText.ONLY_ALPHA;
            case "num", "numeric", "onlynumeric": filterMode = FlxInputText.ONLY_NUMERIC;
            case "alphanum", "alphanumeric", "onlyalphanumeric": filterMode = FlxInputText.ONLY_ALPHANUMERIC;
            case "a", "n", "an":
                    throw new Error("FlxUI._loadInputText(): 1 letter values have been deprecated (filter attribute).");
            default: filterMode = FlxInputText.NO_FILTER;
        }
            
        fti.setFormat(the_font, size, color, align);
        fti.forceCase = forceCase;
        fti.filterMode = filterMode;
        border.apply(fti);
        fti.drawFrame();
        ft = fti;
        
        if (data.hasNode.param)
        {
            var params = FlxUI.getParams(data);
            var ihp:IHasParams = cast ft;
            ihp.params = params;
        }
        
        if (H > 0 && ft.height != H)
        {
            if (Std.is(ft, IResizable))
            {
                var r:IResizable = cast ft;
                r.resize(r.width, H);
            }
        }
        
        return ft;
    }
}