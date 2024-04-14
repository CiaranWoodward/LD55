extends ProductionBuilding

@export var max_corn: int = 10
@export var corn_per_cat: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	base_build_time = 5
	_queue[Global.ResourceType.CORN] = max_corn - _inventory[Global.ResourceType.CORN]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func do_build():
	super.do_build()
	if (_inventory[Global.ResourceType.CORN] >= corn_per_cat):
		var cat: Cat = load("res://Characters/Cat.tscn").instantiate()
		cat.position = self.position
		Global.game_map.add_character(cat)
		change_inventory_count(Global.ResourceType.CORN, -corn_per_cat)
		change_queue_count(Global.ResourceType.CORN, corn_per_cat)
