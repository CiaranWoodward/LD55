class_name ProductionBuilding
extends Building

@export var cat_slots: int = 2
@export var cost: int = 10
@export var base_build_time: float = 5.0
@export var cat_time_multiplier: float = 0.9

@onready var build_timer = Timer.new()
var cat_count: int = 0 : set = set_cat_count
var as_ui_part: bool = false : set = set_as_ui_part

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	add_child(build_timer)
	build_timer.stop();
	build_timer.timeout.connect(do_build)

func set_cat_count(newCount):
	if newCount <= 0:
		newCount = 0
		build_timer.stop()
	else:
		build_timer.wait_time = base_build_time * pow(cat_time_multiplier, cat_count)
		if build_timer.is_stopped():
			build_timer.start()
	cat_count = newCount

func set_as_ui_part(newValue):
	if newValue == as_ui_part:
		return
	as_ui_part = newValue
	if (as_ui_part):
		build_timer.stop()
		$WorkingNavigationRegion.enabled = false
	else:
		$WorkingNavigationRegion.enabled = true
		set_cat_count(cat_count)

func is_cost_affordable() -> bool:
	return Global.get_resource_count(Global.ResourceType.GOLD) >= cost

func buy():
	Global.change_resource_count(Global.ResourceType.GOLD, -cost)

func can_build_here() -> bool:
	return !$BuildPrevention.get_overlapping_areas().is_empty()
	
func take_me(character: BaseCharacter):
	if (character is Cat):
		if (cat_count < cat_slots):
			set_cat_count(cat_count + 1)
			employ(character)
			return true
	return false

func employ(character: Cat):
	character.change_job(self)
	character.nav.set_navigation_map($WorkingNavigationRegion.get_navigation_map())
	character.reparent($Graphic)

func get_random_point_in_building_ish() -> Vector2:
	var rect: Rect2 = $BuildPrevention/BuildPreventionShape.shape.get_rect()
	rect.position += $BuildPrevention/BuildPreventionShape.global_position
	return Vector2(rect.position.x + randf_range(0, rect.size.x), rect.position.y + randf_range(0, rect.size.y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func do_build():
	pass
