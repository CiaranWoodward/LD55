class_name HoldingPen
extends Building

@export var character_slots: int = 5
@export var holding_type: Global.ResourceType = Global.ResourceType.GRANNY

func _get_character_count():
	return _inventory[holding_type]
	
func set_as_ui_part(newValue):
	if newValue == as_ui_part:
		return
	as_ui_part = newValue
	if (as_ui_part):
		$HoldingNavigationRegion.enabled = false
	else:
		$HoldingNavigationRegion.enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_queue[holding_type] = _get_character_count() - character_slots
	super._ready()
	
func take_me(character: BaseCharacter):
	if (character is HoldableCharacter && character.get_type() == holding_type):
		if (_get_character_count() < character_slots):
			change_inventory_count(holding_type, 1)
			hold(character)
			return true
	return false

func handle_character(character: BaseCharacter):
	if take_me(character):
		character.jump_to(get_random_point_in_building_ish(), func(): 
			character.current_target = null
			character._find_new_target()
		)
	
func hold(character: HoldableCharacter):
	character.change_held_by(self)
	character.nav.set_navigation_map($HoldingNavigationRegion.get_navigation_map())
	
func get_random_point_in_building_ish() -> Vector2:
	var rect: Rect2 = $BuildPrevention/BuildPreventionShape.shape.get_rect()
	rect.position += $BuildPrevention/BuildPreventionShape.global_position
	return Vector2(rect.position.x + randf_range(0, rect.size.x), rect.position.y + randf_range(0, rect.size.y))
