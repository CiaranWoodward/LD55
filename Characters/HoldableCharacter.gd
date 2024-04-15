class_name HoldableCharacter
extends BaseCharacter

var _pen: HoldingPen
var _inventory

func change_held_by(pen: HoldingPen = null):
	if is_held():
		_pen.change_inventory_count(get_type(), -1)
		_pen.change_queue_count(get_type(), -1)
	_pen = pen
	if is_held():
		nav.navigation_layers = 2
	else:
		nav.navigation_layers = 1

func _get_random_target_position() -> Vector2:
	if is_held():
		return _pen.get_random_point_in_building_ish()
	else:
		return super._get_random_target_position()

func is_held() -> bool:
	return is_instance_valid(_pen)

func pick_up() -> bool:
	if !super.pick_up():
		return false
	change_held_by()
	return true
