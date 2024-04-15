extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.resource_updated.connect(_resources_updated)
	_resources_updated()

func _resources_updated():
	text = "%s" % Global.get_resource_count(Global.ResourceType.GOLD)
