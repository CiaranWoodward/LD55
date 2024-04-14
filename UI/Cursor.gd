class_name Cursor
extends Node2D

enum ActionType {NONE, BUILD, DRAG}

@export var idle_color : Color = Color.WHITE
@export var invalid_color : Color = Color.RED
@export var valid_color : Color = Color.WHITE

var _current_character: BaseCharacter
var _current_building: ProductionBuilding
var _current_action : ActionType = ActionType.NONE
var _mouse_pressed = false

func _unhandled_input(event):
	if event is InputEventMouseButton && (event.button_index == MOUSE_BUTTON_LEFT):
		var e = event as InputEventMouseButton
		if e.is_pressed():
			_mouse_pressed = true
			_apply_pressed_action()
		else:
			if _mouse_pressed:
				_apply_released_action()
			_mouse_pressed = false
	if event is InputEventMouseButton && (event.button_index == MOUSE_BUTTON_RIGHT):
		var e = event as InputEventMouseButton
		if e.is_pressed():
			clear_action()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.cursor = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position()
	if _current_action == ActionType.DRAG:
		_current_character.drag_to(position)

# Called every physics tick. 'delta' is the elapsed time since the previous tick.
func _physics_process(delta):
	if _current_action == ActionType.BUILD:
		if !_current_building.is_cost_affordable():
			clear_action()
		elif _current_building.can_build_here():
			$Building.modulate = invalid_color
		else:
			$Building.modulate = valid_color
	
func _change_action(newAction: ActionType):
	_remove_building()
	_current_character = null
	_current_action = newAction

func _remove_building():
	if is_instance_valid(_current_building):
		$Building.remove_child(_current_building)
		_current_building.queue_free()
	_current_building = null
	return

func _apply_pressed_action():
	if _current_action == ActionType.NONE:
		var areas = $PickArea.get_overlapping_areas()
		areas.sort_custom(func(a, b): return a.global_position.distance_squared_to(self.global_position) < b.global_position.distance_squared_to(self.global_position))
		for area in areas:
			var parent = area.get_parent()
			if parent is BaseCharacter and parent.pick_up():
				pick_up(parent)
				break

func _apply_released_action():
	if _current_action == ActionType.BUILD:
		var gcoords = _current_building.global_position
		$Building.remove_child(_current_building)
		Global.game_map.add_building_child(_current_building, gcoords)
		_current_building = null
		clear_action()
	elif _current_action == ActionType.DRAG:
		drop()

func clear_action():
	_change_action(ActionType.NONE)

func is_free():
	return _current_action == ActionType.NONE

func set_building(newBuilding: ProductionBuilding):
	_remove_building()
	_change_action(ActionType.BUILD)
	_current_building = newBuilding
	$Building.add_child(_current_building)
	_current_building.as_ui_part = true

func pick_up(character: BaseCharacter):
	assert(is_free())
	_change_action(ActionType.DRAG)
	_current_character = character

func drop():
	assert(_current_action == ActionType.DRAG)
	_current_character.put_down()
	clear_action()
