class_name Cat
extends BaseCharacter

var _building: ProductionBuilding

var _inventory: Dictionary = Global.ResourceType.values().reduce(func(accum, type):
	accum[type] = 0
	return accum, {})

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)
	
func get_type():
	return Global.ResourceType.CAT
# use this to read inventory to give to building in find next target	
# Global.ResourceType.values().filter(func(type): return get_resource_count(type) > 0)

func has_resource(type: Global.ResourceType) -> bool:
	if (type == get_type()): return true
	if (is_instance_valid(_inventory[type])): return _inventory[type]
	return false

func change_job(building = null):
	if is_employed():
		_building.cat_count -= 1
	_building = building
	$Graphic/Character/Hat.visible = is_employed()

func is_employed() -> bool:
	return is_instance_valid(_building)

func pick_up() -> bool:
	if !super.pick_up():
		return false
	change_job()
	return true
