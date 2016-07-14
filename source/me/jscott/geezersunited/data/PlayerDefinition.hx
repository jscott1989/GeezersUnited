package me.jscott.geezersunited.data;

class PlayerDefinition {
    var id:Int;
    var name:String;

    public function getID() { return id; }
    public function getName() { return name; }

    public function new(id:Int, name:String) {
        this.id = id;
        this.name = name;
    }
}