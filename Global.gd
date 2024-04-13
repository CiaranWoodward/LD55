extends Node

signal resource_updated

enum BuildingType {
	PORTAL,
	RECUTEMENT_CENTRE,
	SHEEP_FARM,
	GRANARY,
	NURSING_HOME,
	FISH_POND
}

enum ResourceType {
	GOLD,
	WHEAT,
	FISH,
}

# inventory for resources
var _resourceInventory: Dictionary = ResourceType.values().reduce(func(accum, type):
	accum[type] = 0
	return accum, {})

# Functions for interacting with inventory
func get_resource_count(type: ResourceType):
	return _resourceInventory[type]
	resource_updated.emit()
func set_resource_count(type: ResourceType, count: int):
	_resourceInventory[type] = count
	resource_updated.emit()
func change_resource_count(type: ResourceType, delta: int):
	_resourceInventory[type] += delta
	resource_updated.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
