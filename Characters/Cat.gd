class_name Cat
extends BaseCharacter

@export var head_colors: Array[Color] = [Color.BISQUE]
@export var pattern_colors: Array[Color] = [Color.CORAL]
@export var eye_colors: Array[Color] = [Color.SKY_BLUE]

var _building: ProductionBuilding
var _inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_restyle()

func _restyle():
	var c = head_colors.pick_random()
	$Graphic/Character/Body.self_modulate = c
	$Graphic/Character/Head.self_modulate = c
	c = pattern_colors.pick_random()
	$Graphic/Character/Paws.self_modulate = c
	$Graphic/Character/Pattern.self_modulate = c
	c = eye_colors.pick_random()
	$Graphic/Character/Face.self_modulate = c
	$Graphic/Character/Shocc.self_modulate = c
	randomize_frame($Graphic/Character/Head)
	randomize_frame($Graphic/Character/Face)
	randomize_frame($Graphic/Character/Pattern)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)

func get_resource_to_queue() -> Global.ResourceType:
	if _inventory != null: 
		return _inventory 
	return get_type()
	
func get_type():
	return Global.ResourceType.CAT
# use this to read inventory to give to building in find next target	
# Global.ResourceType.values().filter(func(type): return get_resource_count(type) > 0)

func has_resource(type: Global.ResourceType) -> bool:
	if (type == get_type()): return true
	if (type == _inventory): return true
	return false
	
func remove_resource():
	_inventory = null
	resource = null

func give_resource(type: Global.ResourceType):
	assert(!is_instance_valid(_inventory))
	#assert(resource == type)
	resource = type
	_inventory = type

func change_job(building = null):
	if is_employed():
		_building.cat_count -= 1
	_building = building
	$Graphic/Character/Hat.visible = is_employed()
	if is_employed():
		nav.navigation_layers = 2
	else:
		nav.navigation_layers = 1
		Global.game_map.add_character(self)

func _get_random_target_position() -> Vector2:
	if is_employed():
		return _building.get_random_point_in_building_ish()
	else:
		return super._get_random_target_position()

func is_employed() -> bool:
	return is_instance_valid(_building)

func is_job_blocked() -> bool:
	return is_employed() && _building.is_job_blocked()

func pick_up() -> bool:
	if !super.pick_up():
		return false
	change_job()
	return true
