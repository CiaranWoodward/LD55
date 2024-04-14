extends ProductionBuilding

@export var max_corn: int = 10
@export var corn_per_granny: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	_queue[Global.ResourceType.CORN] = _inventory[Global.ResourceType.CORN] - max_corn
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func do_build():
	super.do_build()
	if (_inventory[Global.ResourceType.CORN] >= corn_per_granny):
		var granny: Granny = load("res://Characters/Granny.tscn").instantiate()
		granny.position = self.position
		Global.game_map.add_character(granny)
		change_inventory_count(Global.ResourceType.CORN, -corn_per_granny)
		change_queue_count(Global.ResourceType.CORN, -corn_per_granny)

func handle_character(character: BaseCharacter):
	if (character is Cat):
		if (character.has_resource(Global.ResourceType.CORN)):
			character.remove_resource()
			change_inventory_count(Global.ResourceType.CORN, 1)
