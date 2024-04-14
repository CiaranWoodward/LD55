extends ProductionBuilding

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func do_build():
	super.do_build()
	var cat: Cat = load("res://Characters/Cat.tscn").instantiate()
	cat.position = self.position
	Global.game_map.add_character(cat)
