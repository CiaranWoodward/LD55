class_name Cat
extends BaseCharacter

var _inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	_inventory = Global.ResourceType.CORN
	super._ready()

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
