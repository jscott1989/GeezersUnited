package me.jscott.ui;

import me.jscott.ui.Menu;

interface Menuable {
    public function openMenu(menu:Menu):Void;
    public function closeMenu():Void;
}