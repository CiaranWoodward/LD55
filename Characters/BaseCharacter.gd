class_name BaseCharacter
extends CharacterBody2D

@export var movement_speed: float = 100
@export var acceleration: float = 7
@export var pickup_height: float = 25
@export var head_height: float = 15

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var area: Area2D = Area2D.new()

var current_target: Building
var _picked_up: bool = false
var _jumping: bool = false
var _ghosted: bool = false
var _last_valid_location : Vector2
var _pick_up_tween: Tween
var _jump_tween: Tween
var _pickup_offset: Vector2 = Vector2.ZERO
var resource
@onready var _stashed_collision_layer = collision_layer
	
func has_resource(type: Global.ResourceType) -> bool:
	return type == get_type()

func _ready():
	add_to_group("characters")
	_find_new_target()
	_last_valid_location = global_position
	collision_layer = Global.PhysicsLayer.CHARACTER
	collision_mask = Global.PhysicsLayer.BUILDING | Global.PhysicsLayer.NORMAL
	_configure_area()
	#nav.debug_enabled = true
	
func _configure_area():
	var colshape = CollisionShape2D.new()
	colshape.shape = $CollisionShape2D.shape
	area.add_child(colshape)
	area.monitoring = true
	area.monitorable = true
	area.collision_layer = Global.PhysicsLayer.CHARACTER
	area.collision_mask = Global.PhysicsLayer.CHARACTER
	add_child(area)
	
func get_resource_to_queue() -> Global.ResourceType:
	return get_type()

func _get_random_target_position() -> Vector2:
	return global_position + Vector2(400,0).rotated(2*PI*randf())

func _find_new_target():
	# find resources of this charecter
	var resourceToQueue = get_resource_to_queue()
	
	# for each resource find the closest building which requires it	
	var potential_buildings = []
	if !is_employed() && !is_held():
		for building: Building in get_tree().get_nodes_in_group("buildings"):
			if (building.get_queue_count(resourceToQueue) < 0): potential_buildings.append(building)
		
	var target_position: Vector2
	if potential_buildings.is_empty():
		# random walk
		current_target = null
		target_position = _get_random_target_position()
		current_target = null
	else:
		# target building and add self to queue
		resource = resourceToQueue
		potential_buildings.sort_custom(func(a: Building, b: Building): return a.pathing_desirability(self) > b.pathing_desirability(self))
		current_target = potential_buildings.front()
		target_position = current_target.global_position
		current_target.change_queue_count(resource, 1)
		current_target.on_nav_start(self)
	
	nav.target_position = target_position
	nav.target_desired_distance = 50

func _physics_process(delta):
	if _picked_up or _jumping or _ghosted:
		return
	if nav.is_navigation_finished():
		if is_instance_valid(current_target):
			current_target.handle_character(self)
			current_target.on_nav_end(self)
			current_target = null
		else:
			_find_new_target()
	
	var direction = Vector3();
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * movement_speed, acceleration * delta)
	
	var slowdown = Vector2.ZERO
	for a in area.get_overlapping_areas():
		slowdown += (global_position - a.global_position).normalized()
	if slowdown != Vector2.ZERO:
		var speed = velocity.length()
		velocity += slowdown * (speed / 4)
		if velocity.length() > speed:
			velocity = velocity.normalized() * speed
	
	if !(is_employed() && is_job_blocked()): # Stop moving if we're working but the building can't do anything
		move_and_slide()

func _process(delta):
	if _ghosted:
		_oblivion_process(delta)

func _new_pickup_tween():
	if _pick_up_tween:
		_pick_up_tween.kill()
	if _jump_tween:
		_jump_tween.kill()
	_pick_up_tween = create_tween()

func _pickup_tween_up():
	_pick_up_tween.tween_property($Graphic, "position", Vector2(0, -pickup_height), 0.2)
	_pick_up_tween.parallel().tween_property($Graphic, "scale", Vector2(0.9,1.1), 0.2)
	_pick_up_tween.parallel().tween_property($Graphic/Walk, "speed_scale", 2, 0.2)
	_pick_up_tween.parallel().tween_property($Graphic/Character/Shocc, "visible", true, 0.2)
	_pick_up_tween.parallel().tween_property(self, "_pickup_offset", Vector2(0, pickup_height + head_height), 0.2)
	_pick_up_tween.parallel().tween_property($Shadow, "scale", Vector2(0.8,0.8), 0.2)

func _pickup_tween_down():
	_pick_up_tween.tween_property($Graphic, "position", Vector2.ZERO, 0.2)
	_pick_up_tween.parallel().tween_property($Graphic, "scale", Vector2(1,1), 0.2)
	_pick_up_tween.parallel().tween_property($Graphic/Walk, "speed_scale", 1, 0.2)
	_pick_up_tween.parallel().tween_property($Graphic/Character/Shocc, "visible", false, 0.2)
	_pick_up_tween.parallel().tween_property(self, "_pickup_offset", Vector2.ZERO, 0.2)
	_pick_up_tween.parallel().tween_property($Shadow, "scale", Vector2(1,1), 0.2)

func _new_jump_tween():
	if _jump_tween:
		_jump_tween.kill()
	_jump_tween = create_tween()

func _jump_tween_to(destination: Vector2, callback: Callable):
	_new_pickup_tween()
	_new_jump_tween()
	_jumping = true
	_pickup_tween_up()
	_pickup_tween_down()
	_jump_tween.tween_property(self, "global_position", destination, 0.4)
	_jump_tween.tween_property(self, "_jumping", false, 0)
	_jump_tween.tween_callback(callback)

func jump_to(destination: Vector2, callback: Callable = func():pass):
	assert(!_jumping)
	_jump_tween_to(destination, callback)

func pick_up() -> bool:
	if _picked_up:
		return false
	_picked_up = true
	_jumping = false
	if (is_instance_valid(current_target) && resource != null):
		current_target.change_queue_count(resource, -1)
		current_target.on_nav_end(self)
	resource = null
	current_target = null
	_stashed_collision_layer = collision_layer
	collision_layer = 0
	z_index = 10
	_new_pickup_tween()
	_pickup_tween_up()
	return true

func drag_to(gcoords: Vector2):
	global_position = gcoords + _pickup_offset
	var building = Global.game_map.get_building_at_point(gcoords)
	if !is_instance_valid(building):
		_last_valid_location = gcoords

func put_down():
	assert(_picked_up)
	_picked_up = false
	collision_layer = _stashed_collision_layer
	z_index = 0
	velocity = Vector2.ZERO
	var building = Global.game_map.get_building_at_point(global_position)
	_new_pickup_tween()
	_pickup_tween_down()
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

func get_type():
	pass

func is_employed() -> bool:
	return false
func is_held() -> bool:
	return false
func is_job_blocked() -> bool:
	return false

func randomize_frame(animated_sprite: AnimatedSprite2D):
	animated_sprite.frame = randi_range(0, animated_sprite.sprite_frames.get_frame_count(animated_sprite.animation))

var _oblivion_start: Vector2
var _oblivion_point: Node2D
var _oblivion_progress: float = 0.0
var _oblivion_spin: float
func ghostify_to_oblivion(oblivion: Node2D) -> Tween:
	_ghosted = true
	_oblivion_point = oblivion
	collision_layer = 0
	collision_mask = 0
	area.monitorable = false
	area.monitoring = false
	_oblivion_start = global_position
	_oblivion_spin = (PI * 4) * randf_range(0.8, 1.2)
	z_index = 12
	if randi_range(0, 1) == 0:
		_oblivion_spin = -_oblivion_spin
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "_oblivion_progress", 1.0, 0.7).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	return tween

func _oblivion_process(delta: float):
	rotate(_oblivion_spin * delta)
	self.global_position = _oblivion_start.lerp(_oblivion_point.global_position, _oblivion_progress)
