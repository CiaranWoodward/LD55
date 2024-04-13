class_name BaseCharacter
extends CharacterBody2D

@export var movement_speed: float = 100
@export var acceleration: float = 7
@export var pickup_height: float = 25
@export var head_height: float = 15

@onready var nav: NavigationAgent2D = $NavigationAgent2D

var current_target: Building
var _picked_up: bool = false
@onready var _stashed_collision_layer = collision_layer

func _ready():
	input_pickable = true
	add_to_group("characters")
	_find_new_target()
	
func _find_new_target():
	var potential_buildings = get_tree().get_nodes_in_group("buildings").filter(
		func(building: Building): return building.do_you_want_me(self)
		)
	if potential_buildings.is_empty():
		return
	potential_buildings.sort_custom(func(a: Building, b: Building): return a.distance_squared_to_me(self) < b.distance_squared_to_me(self))
	current_target = potential_buildings.front()
	var target_position: Vector2 = current_target.global_position
	nav.target_position = target_position

func _physics_process(delta):
	if is_instance_valid(current_target) && nav.is_navigation_finished():
		if current_target.take_me(self):
			current_target = null
		else:
			_find_new_target()
	
	if is_instance_valid(current_target):
		var direction = Vector3();
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * movement_speed, acceleration * delta)
		
		move_and_slide()

func pick_up():
	if Global.cursor.is_free():
		Global.cursor.pick_up(self)
		input_pickable = false
		get_node("Graphic").position.y = -pickup_height
		current_target = null
		_stashed_collision_layer = collision_layer
		collision_layer = 0

func drag_to(gcoords: Vector2):
	global_position = gcoords + Vector2(0, pickup_height + head_height)

func put_down():
	input_pickable = true
	get_node("Graphic").position.y = 0
	collision_layer = _stashed_collision_layer
	velocity = Vector2.ZERO
	_find_new_target()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && (event.button_index == MOUSE_BUTTON_LEFT):
		var e = event as InputEventMouseButton
		if e.is_pressed():
			pick_up()
