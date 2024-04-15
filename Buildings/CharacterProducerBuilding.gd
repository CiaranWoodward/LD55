class_name CharacterProducerBuilding
extends ProductionBuilding

@export var character_cost: int = 2

func _get_input_type():
	pass

func _create_character() -> BaseCharacter:
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	_queue[_get_input_type()] = _inventory[_get_input_type()] - max_inventory
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func do_build():
	super.do_build()
	if (_inventory[_get_input_type()] >= character_cost):
		var character: BaseCharacter = _create_character()
		character.position = self.position
		Global.game_map.add_character(character)
		change_inventory_count(_get_input_type(), -character_cost)
		change_queue_count(_get_input_type(), -character_cost)

func handle_character(character: BaseCharacter):
	if (character is Cat):
		if (character.has_resource(_get_input_type())):
			character.remove_resource()
			change_inventory_count(_get_input_type(), 1)

func is_job_blocked() -> bool:
	return super.is_job_blocked() or get_inventory_count(_get_input_type()) < character_cost
