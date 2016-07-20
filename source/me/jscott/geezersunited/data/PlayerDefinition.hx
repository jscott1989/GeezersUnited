package me.jscott.geezersunited.data;

class PlayerDefinition {
    var id:Int;
    var name:String;

    var stats:Map<String, Int>;

    public function getID() { return id; }
    public function getName() { return name; }
    public function getSurname() { 
        var f = name.split(" ");
        return f[f.length - 1];
    }
    public function getStat(name:String) {
        return stats.get(name);
    }
    public function getStatMultiplier(name:String) {
        return getStat(name)/100;
    }

    public function new(id:Int, name:String, stats:Map<String, Int>) {
        this.id = id;
        this.name = name;
        this.stats = stats;
    }
}