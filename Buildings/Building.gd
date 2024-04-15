class_name Building
extends Node2D

@export var cost: int = 10

var transport_count = 0
var as_ui_part: bool = false : set = set_as_ui_part

var _inventory: Dictionary = Global.ResourceType.values().reduce(func(accum, type):
	accum[type] = 0
	return accum, {})
	
var _queue: Dictionary = Global.ResourceType.values().reduce(func(accum, type):
	accum[type] = 0
	return accum, {})
	
func get_inventory_count(type: Global.ResourceType) -> int:
	return _inventory[type]
	
func get_queue_count(type: Global.ResourceType) -> int:
	return _queue[type]
	
func change_queue_count(type: Global.ResourceType, delta: int):
	_queue[type] = _queue[type] + delta;
	
func change_inventory_count(type: Global.ResourceType, delta: int):
	_inventory[type] = _inventory[type] + delta;
	
func handle_character(character: BaseCharacter):
	pass
	
func take_me(character: BaseCharacter):
	pass

func set_as_ui_part(newValue):
	as_ui_part = newValue

func is_cost_affordable() -> bool:
	return Global.get_resource_count(Global.ResourceType.GOLD) >= cost

func buy():
	Global.change_resource_count(Global.ResourceType.GOLD, -cost)

func can_build_here() -> bool:
	return !$BuildPrevention.get_overlapping_areas().is_empty()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("buildings")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pathing_desirability(character: BaseCharacter) -> float:
	if character.resource == null: return 0
	return 1/((1+transport_count)*character.global_position.distance_squared_to(global_position))
	
func on_nav_start(character: BaseCharacter):
	transport_count += 1
	
func on_nav_end(character: BaseCharacter):
	transport_count -= 1
