class_name Building
extends Node2D

var _inventory: Dictionary = Global.ResourceType.values().reduce(func(accum, type):
	accum[type] = 0
	return accum, {})
	
var _queue: Dictionary = Global.ResourceType.values().reduce(func(accum, type):
	accum[type] = 0
	return accum, {})
	
func get_inventory_count(type: Global.ResourceType) -> int:
	return _inventory[type];
	
func get_queue_count(type: Global.ResourceType) -> int:
	return _queue[type];
	
func change_queue_count(type: Global.ResourceType, delta: int):
	_queue[type] = _queue[type] + delta;
	
func handle_character(character: BaseCharacter):
	pass
	
func take_me(character: BaseCharacter):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("buildings")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func distance_squared_to_me(character: BaseCharacter):
	return character.global_position.distance_squared_to(global_position)
