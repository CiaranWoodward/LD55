class_name ProductionBuilding
extends Building

@export var cat_slots: int = 2
@export var cost: int = 10
@export var base_build_time: float = 2.0
@export var cat_time_multiplier: float = 1.8

@onready var build_timer = Timer.new()
var cat_count: int = 0 : set = set_cat_count
var as_ui_part: bool = false : set = set_as_ui_part

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	add_child(build_timer)
	build_timer.wait_time = 1
	build_timer.start();
	build_timer.timeout.connect(do_build)

func set_cat_count(newCount):
	if newCount == 0:
		build_timer.stop()
	else:
		base_build_time / (cat_time_multiplier * cat_count)
		if build_timer.is_stopped():
			build_timer.start()
	cat_count = newCount

func set_as_ui_part(newValue):
	if newValue == as_ui_part:
		return
	as_ui_part = newValue
	if (as_ui_part):
		build_timer.stop()
	else:
		build_timer.start()

func is_cost_affordable() -> bool:
	return Global.get_resource_count(Global.ResourceType.GOLD) >= cost

func buy():
	Global.change_resource_count(Global.ResourceType.GOLD, -cost)

func can_build_here() -> bool:
	return !$BuildPrevention.get_overlapping_areas().is_empty()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func do_build():
	pass
