class_name ProductionBuilding
extends Node2D

@export var cat_slots: int = 2
@export var cost: int = 10
@export var base_build_time: float = 2.0
@export var cat_time_multiplier: float = 1.8

@onready var build_timer = Timer.new()
var cat_count: int = 0 : set = set_cat_count

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(build_timer)
	build_timer.stop();
	build_timer.timeout.connect(do_build)

func set_cat_count(newCount):
	if newCount == 0:
		build_timer.stop()
	else:
		build_timer.wait_time = base_build_time / (cat_time_multiplier * cat_count)
		if build_timer.is_stopped():
			build_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func do_build():
	pass
