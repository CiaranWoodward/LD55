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
var _last_valid_location : Vector2
var _pick_up_tween: Tween
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

func _find_new_target():
	# find resources of this charecter
	var resourceToQueue = get_resource_to_queue()
	
	# for each resource find the closest building which requires it	
	var potential_buildings = []
	for building: Building in get_tree().get_nodes_in_group("buildings"):
		if (building.get_queue_count(resourceToQueue) < 0): potential_buildings.append(building)
		
	var target_position: Vector2
	if potential_buildings.is_empty():
		# random walk
		current_target = null
		target_position = global_position + Vector2(100,0).rotated(2*PI*randf())
	else:
		# target building and add self to queue
		potential_buildings.sort_custom(func(a: Building, b: Building): return a.distance_squared_to_me(self) < b.distance_squared_to_me(self))
		current_target = potential_buildings.front()
		target_position = current_target.global_position
		current_target.change_queue_count(resourceToQueue, 1)
		resource = resourceToQueue
	
	nav.target_position = target_position
	nav.target_desired_distance = 50

func _physics_process(delta):
	if _picked_up:
		return
	if nav.is_target_reached():
		if is_instance_valid(current_target):
			current_target.handle_character(self)
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
		velocity += slowdown * (movement_speed / 10.0)
	
	move_and_slide()

func _new_pickup_tween():
	if _pick_up_tween:
		_pick_up_tween.kill()
	_pick_up_tween = create_tween()

func pick_up() -> bool:
	if _picked_up:
		return false
	_picked_up = true
	if (is_instance_valid(current_target) && resource != null):
		current_target.change_queue_count(resource, -1)
	resource = null
	current_target = null
	_stashed_collision_layer = collision_layer
	collision_layer = 0
	_new_pickup_tween()
	_pick_up_tween.parallel().tween_property($Graphic, "position", Vector2(0, -pickup_height), 0.2)
	_pick_up_tween.parallel().tween_property($Graphic, "scale", Vector2(0.9,1.1), 0.2)
	_pick_up_tween.parallel().tween_property($Graphic/Walk, "speed_scale", 2, 0.2)
	_pick_up_tween.parallel().tween_property($Graphic/Character/Shocc, "visible", true, 0.2)
	_pick_up_tween.parallel().tween_property(self, "_pickup_offset", Vector2(0, pickup_height + head_height), 0.2)
	_pick_up_tween.parallel().tween_property($Shadow, "scale", Vector2(0.8,0.8), 0.2)
	return true

func drag_to(gcoords: Vector2):
	global_position = gcoords + _pickup_offset
	var building = Global.game_map.get_building_at_point(gcoords)
	if !is_instance_valid(building):
		_last_valid_location = gcoords

func put_down():
	assert(_picked_up)
	_picked_up = false
	_new_pickup_tween()
	_pick_up_tween.tween_property(get_node("Graphic"), "position", Vector2.ZERO, 0.2)
	_pick_up_tween.parallel().tween_property($Graphic, "scale", Vector2(1,1), 0.2)
	_pick_up_tween.parallel().tween_property($Graphic/Walk, "speed_scale", 1, 0.2)
	_pick_up_tween.parallel().tween_property($Graphic/Character/Shocc, "visible", false, 0.2)
	_pick_up_tween.parallel().tween_property(self, "_pickup_offset", Vector2.ZERO, 0.2)
	_pick_up_tween.parallel().tween_property($Shadow, "scale", Vector2(1,1), 0.2)
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

func get_type():
	pass
