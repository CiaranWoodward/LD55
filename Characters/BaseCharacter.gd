class_name BaseCharacter
extends CharacterBody2D

@export var movement_speed: float = 100
@export var acceleration: float = 7
@export var pickup_height: float = 25
@export var head_height: float = 15

@onready var nav: NavigationAgent2D = $NavigationAgent2D

var current_target: Building
var _picked_up: bool = false
var _last_valid_location : Vector2
var _pick_up_tween: Tween
var _pickup_offset: Vector2 = Vector2.ZERO
@onready var _stashed_collision_layer = collision_layer

func _ready():
	input_pickable = true
	add_to_group("characters")
	_find_new_target()
	_last_valid_location = global_position
	
func _find_new_target():
	var potential_buildings = get_tree().get_nodes_in_group("buildings").filter(
		func(building: Building): return building.do_you_want_me(self)
		)
		
	var target_position: Vector2
	if potential_buildings.is_empty():
		target_position = global_position + Vector2(100,0).rotated(2*PI*randf())
	else:
		potential_buildings.sort_custom(func(a: Building, b: Building): return a.distance_squared_to_me(self) < b.distance_squared_to_me(self))
		current_target = potential_buildings.front()
		target_position = current_target.global_position
		
	nav.target_position = target_position
	nav.target_desired_distance = 50

func _physics_process(delta):
	if _picked_up:
		return
	if nav.is_target_reached():
		if is_instance_valid(current_target) && current_target.take_me(self):
			current_target = null
		else:
			_find_new_target()
	
	var direction = Vector3();
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * movement_speed, acceleration * delta)
	move_and_slide()

func _new_pickup_tween():
	if _pick_up_tween:
		_pick_up_tween.kill()
	_pick_up_tween = create_tween()

func pick_up():
	assert(!_picked_up)
	if Global.cursor.is_free():
		Global.cursor.pick_up(self)
		_picked_up = true
		input_pickable = false
		current_target = null
		_stashed_collision_layer = collision_layer
		collision_layer = 0
		_new_pickup_tween()
		_pick_up_tween.tween_property(get_node("Graphic"), "position", Vector2(0, -pickup_height), 0.2)
		_pick_up_tween.parallel().tween_property(self, "_pickup_offset", Vector2(0, pickup_height + head_height), 0.2)

func drag_to(gcoords: Vector2):
	global_position = gcoords + _pickup_offset
	var building = Global.game_map.get_building_at_point(gcoords)
	if !is_instance_valid(building):
		_last_valid_location = gcoords

func put_down():
	assert(_picked_up)
	input_pickable = true
	_picked_up = false
	_new_pickup_tween()
	_pick_up_tween.tween_property(get_node("Graphic"), "position", Vector2.ZERO, 0.2)
	_pick_up_tween.parallel().tween_property(self, "_pickup_offset", Vector2.ZERO, 0.2)
	collision_layer = _stashed_collision_layer
	velocity = Vector2.ZERO
	var building = Global.game_map.get_building_at_point(global_position)
	if is_instance_valid(building):
		if building.take_me(self):
			return
		else:
			_pick_up_tween.parallel().tween_property(self, "global_position", _last_valid_location, 0.2)
	_pick_up_tween.tween_callback(self._find_new_target)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && (event.button_index == MOUSE_BUTTON_LEFT):
		var e = event as InputEventMouseButton
		if e.is_pressed():
			pick_up()
