extends ProductionBuilding

@export var max_fish: int = 10
@export var fish_per_cat: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	_queue[Global.ResourceType.FISH] = _inventory[Global.ResourceType.FISH] - max_fish
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func do_build():
	super.do_build()
	if (_inventory[Global.ResourceType.FISH] >= fish_per_cat):
		var cat: Cat = load("res://Characters/Cat.tscn").instantiate()
		cat.position = self.position
		Global.game_map.add_character(cat)
		change_inventory_count(Global.ResourceType.FISH, -fish_per_cat)
		change_queue_count(Global.ResourceType.FISH, -fish_per_cat)
		
func handle_character(character: BaseCharacter):
	if (character is Cat):
		if (character.has_resource(Global.ResourceType.FISH)):
			character.remove_resource()
			change_inventory_count(Global.ResourceType.FISH, 1)

func employ(cat: Cat):
	super.employ(cat)
