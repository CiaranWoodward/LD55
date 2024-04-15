extends ProductionBuilding

@export var max_soul: int = 10
@export var herb_per_soul: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	_queue[Global.ResourceType.HERB] = _inventory[Global.ResourceType.HERB] - max_soul
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func do_build():
	super.do_build()
	if (_inventory[Global.ResourceType.HERB] >= herb_per_soul):
		var lostSoul: LostSoul = load("res://Characters/LostSoul.tscn").instantiate()
		lostSoul.position = self.position
		Global.game_map.add_character(lostSoul)
		change_inventory_count(Global.ResourceType.HERB, -herb_per_soul)
		change_queue_count(Global.ResourceType.HERB, -herb_per_soul)

func handle_character(character: BaseCharacter):
	if (character is Cat):
		if (character.has_resource(Global.ResourceType.HERB)):
			character.remove_resource()
			change_inventory_count(Global.ResourceType.HERB, 1)

func is_job_blocked() -> bool:
	return super.is_job_blocked() or get_inventory_count(Global.ResourceType.HERB) < herb_per_soul

func employ(cat: Cat):
	super.employ(cat)
