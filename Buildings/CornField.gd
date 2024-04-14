extends ProductionBuilding

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func do_build():
	super.do_build()
	change_inventory_count(Global.ResourceType.CORN, 1)
	change_queue_count(Global.ResourceType.CORN, 1)
	change_queue_count(Global.ResourceType.CAT, -1)

func handle_character(character: BaseCharacter):
	if (character is Cat):
		if (character.has_resource(Global.ResourceType.CAT)):
			character.give_resource(Global.ResourceType.CORN)
			change_inventory_count(Global.ResourceType.CORN, -1)
			change_queue_count(Global.ResourceType.CORN, -1)
			change_queue_count(Global.ResourceType.CAT, 1)
