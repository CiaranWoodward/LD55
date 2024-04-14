extends Node

signal resource_updated

var cursor : Cursor
var game_map: GameMap
var camera: PlayerCam

enum BuildingType {
	PORTAL,
	RECUTEMENT_CENTRE,
	SHEEP_FARM,
	GRANARY,
	NURSING_HOME,
	FISH_POND
}

enum ResourceType {
	CAT,
	GRANNY,
	WITCH,
	GOLD,
	CORN,
	FISH,
}

enum PhysicsLayer {
	NORMAL = 1,
	BUILDING = 2,
	CHARACTER = 4,
	CURSOR = 8,
}

# inventory for resources
var _resourceInventory: Dictionary = ResourceType.values().reduce(func(accum, type):
	accum[type] = 0
	return accum, {})

# Meta-functions
func get_building_name(type: BuildingType) -> String:
	match(type):
		BuildingType.PORTAL: return "Portal"
		BuildingType.RECUTEMENT_CENTRE: return "Recutement Centre"
		BuildingType.SHEEP_FARM: return "Sheep Farm"
		BuildingType.GRANARY: return "Granary"
		BuildingType.NURSING_HOME: return "Nursing Home"
		BuildingType.FISH_POND: return "Fish Pond"
	return ""
func get_building_class(type: BuildingType) -> PackedScene:
	match(type):
		BuildingType.PORTAL: return load("res://Buildings/Portal.tscn")
		BuildingType.RECUTEMENT_CENTRE: return load("res://Buildings/RecutementCentre.tscn")
		BuildingType.SHEEP_FARM: return null
		BuildingType.GRANARY: return null
		BuildingType.NURSING_HOME: return null
		BuildingType.FISH_POND: return null
	return null

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
	set_resource_count(ResourceType.GOLD, 30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
