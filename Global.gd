extends Node

signal resource_updated
signal unlocked

var cursor : Cursor
var game_map: GameMap
var camera: PlayerCam

#Count of bugs that have been released into the world
var bug_count: int = 0
var levels_completed = 0

var _unlocked_summons = [ResourceType.WITCH]
var _unlocked_buildings = [BuildingType.RECUTEMENT_CENTRE, BuildingType.FISH_POND, BuildingType.GRANARY, BuildingType.NURSING_HOME]

func unlock_building(b: BuildingType):
	if _unlocked_buildings.count(b) == 0:
		_unlocked_buildings.append(b)
		unlocked.emit()
func unlock_summon(s: ResourceType):
	if _unlocked_summons.count(s) == 0:
		_unlocked_summons.append(s) 
		unlocked.emit()
func is_building_unlocked(b: BuildingType):
	return _unlocked_buildings.count(b) > 0
func is_summon_unlocked(s: ResourceType):
	return _unlocked_summons.count(s) > 0

# Game state
enum GameState {
	IN_PROGRESS,
	GAME_OVER,
	GAME_WIN
}
var game_state = GameState.IN_PROGRESS

enum BuildingType {
	PORTAL,
	RECUTEMENT_CENTRE,
	SHEEP_FARM,
	GRANARY,
	NURSING_HOME,
	FISH_POND,
	HOLDING_PEN_SHEEP,
	HOLDING_PEN_GRAN,
	HOLDING_PEN_LOST_SOUL,
	FIELD_HOSPITAL,
	HERB_GARDEN,
}

enum ResourceType {
	CAT,
	GRANNY,
	WITCH,
	GOLD,
	CORN,
	FISH,
	HERB,
	SHEEP,
	GHOST,
	SKELETON,
	DEMON,
	LOST_SOUL,
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

func start_summons():
	var delay = 0.0
	for eg in get_tree().get_nodes_in_group("endgames"):
		if delay == 0:
			eg.do_summon()
		else:
			eg.summon_later(delay)
		delay += 10.0

# Meta-functions
func get_building_name(type: BuildingType) -> String:
	match(type):
		BuildingType.PORTAL: return "Portal"
		BuildingType.RECUTEMENT_CENTRE: return "Recutement Centre"
		BuildingType.SHEEP_FARM: return "Sheep Farm"
		BuildingType.GRANARY: return "Corn Field"
		BuildingType.NURSING_HOME: return "Nursing Home"
		BuildingType.FISH_POND: return "Fish Pond"
		BuildingType.HOLDING_PEN_SHEEP: return "Sheep holding pen"
		BuildingType.HOLDING_PEN_GRAN: return "Granny holding pen"
		BuildingType.HOLDING_PEN_LOST_SOUL: return "Lost soul holding pen"
		BuildingType.FIELD_HOSPITAL: return "Field hospital"
		BuildingType.HERB_GARDEN: return "Herb Garden"
	return ""
func get_building(type: BuildingType) -> Building:
	match(type):
		BuildingType.PORTAL: return load("res://Buildings/Portal.tscn").instantiate()
		BuildingType.RECUTEMENT_CENTRE: return load("res://Buildings/RecutementCentre.tscn").instantiate()
		BuildingType.SHEEP_FARM: return load("res://Buildings/SheepBarn.tscn").instantiate()
		BuildingType.GRANARY: return load("res://Buildings/CornField.tscn").instantiate()
		BuildingType.NURSING_HOME: return load("res://Buildings/GrannyShack.tscn").instantiate()
		BuildingType.FISH_POND: return load("res://Buildings/Fishery.tscn").instantiate()
		BuildingType.HOLDING_PEN_SHEEP:
			var pen = load("res://Buildings/HoldingPen.tscn").instantiate()
			pen.holding_type = ResourceType.SHEEP
			return pen
		BuildingType.HOLDING_PEN_GRAN:
			var pen = load("res://Buildings/HoldingPen.tscn").instantiate()
			pen.holding_type = ResourceType.GRANNY
			return pen
		BuildingType.HOLDING_PEN_LOST_SOUL:
			var pen = load("res://Buildings/HoldingPen.tscn").instantiate()
			pen.holding_type = ResourceType.LOST_SOUL
			return pen
		BuildingType.FIELD_HOSPITAL: return load("res://Buildings/FieldHospital.tscn").instantiate()
		BuildingType.HERB_GARDEN: return load("res://Buildings/HerbGarden.tscn").instantiate()
	return null
func get_building_cost(type: BuildingType) -> int:
	match(type):
		BuildingType.RECUTEMENT_CENTRE: return 10
		BuildingType.SHEEP_FARM: return 20
		BuildingType.GRANARY: return 10
		BuildingType.NURSING_HOME: return 10
		BuildingType.FISH_POND: return 10
		BuildingType.HOLDING_PEN_SHEEP: return 15
		BuildingType.HOLDING_PEN_GRAN: return 15
		BuildingType.HOLDING_PEN_LOST_SOUL: return 30
		BuildingType.FIELD_HOSPITAL: return 30
		BuildingType.HERB_GARDEN: return 30
	return INF

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
