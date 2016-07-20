package me.jscott.geezersunited.data;

class PlayerDefinition {
    var id:Int;
    var name:String;

    public function getID() { return id; }
    public function getName() { return name; }
    public function getSurname() { 
        var f = name.split(" ");
        return f[f.length - 1];
    }

    public function new(id:Int, name:String) {
        this.id = id;
        this.name = name;
    }
}