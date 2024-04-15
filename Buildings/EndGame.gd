extends Building

enum GameType {
	WITCHY,
	SPOOKY,
	HELLISH,
	CRYPTIC,
}

@export var timeout: float = 40.0
@export var summon_heal: float = 10.0
@export var summon_count: int = 5
@export var game_type: GameType = GameType.WITCHY
@export var dead_modulate: Color = Color(0.2, 0.2, 0.2)

@onready var _current_timeout = timeout
var _timeout_tween: Tween 

var _sticky_lerpval = 0.0
var _start_gp: Vector2
var _lerp_tween: Tween

var _requirements: Dictionary = Global.ResourceType.values().reduce(func(accum, type):
	accum[type] = 0
	return accum, {})

func change_requirement(type: Global.ResourceType, count: int):
	change_queue_count(type, -count)
	_requirements[type] += count

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_start_gp = $Graphic.global_position
	$Graphic/Shaker/Background/Compo/CompoLabel.text = ["JAM", "COMPO", "EXTRA"].pick_random()
	Global.game_map.games_on_screen_changed.connect(_updated_onscreen)
	_stick_to_screen()
	_prepare_gametype()
	_prepare_timeout()
	_update_label()

func _prepare_gametype():
	match game_type:
		GameType.WITCHY:
			change_requirement(Global.ResourceType.WITCH, summon_count)
		GameType.SPOOKY:
			change_requirement(Global.ResourceType.GHOST, summon_count)
		GameType.HELLISH:
			change_requirement(Global.ResourceType.DEMON, summon_count)
		GameType.CRYPTIC:
			change_requirement(Global.ResourceType.SKELETON, summon_count)

func _is_complete() -> bool:
	for key in _requirements.keys():
		if get_inventory_count(key) < _requirements[key]:
			return false
	return true

func _is_failed() -> bool:
	return _current_timeout <= 0

func _check_completion():
	if _is_complete():
		self.visible = false
	elif _is_failed():
		pass

func _update_label():
	var sum = func(accum, number): return accum + number
	var req_count = _requirements.values().reduce(sum, 0)
	var item_count = _inventory.values().reduce(sum, 0)
	$Graphic/Shaker/Background/TopBar/Counter.text = "(%d/%d)" % [item_count, req_count]

func _prepare_timeout():
	_check_completion()
	if _timeout_tween:
		_timeout_tween.kill()
	_timeout_tween = create_tween()
	var t = _timeout_tween
	if _current_timeout > timeout:
		modulate = Color.WHITE
		$Graphic/Shaker.childhood_trauma = 0.0
		var diff = _current_timeout - timeout
		t.tween_property(self, "_current_timeout", timeout, diff)
		t.tween_interval(0.0)
	else:
		t.tween_property(self, "_current_timeout", 0.0, _current_timeout)
	t.parallel().tween_property(self, "modulate", dead_modulate, _current_timeout)
	t.parallel().tween_property($Graphic/Shaker, "childhood_trauma", 0.7, _current_timeout).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_callback(_check_completion)

func _updated_onscreen(onscreen: bool):
	if onscreen:
		_release_from_screen()
	else:
		_stick_to_screen()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _sticky_lerpval:
		var cam = Global.camera
		var invzoom = Vector2(1/cam.zoom.x, 1/cam.zoom.y)
		var halfscreen = (get_viewport_rect().size/2 * invzoom.x)
		var target_gp = Vector2(global_position.x * invzoom.x, -200 * invzoom.y) + cam.global_position + Vector2(-halfscreen.x, halfscreen.y)
		var target_scale = invzoom
		$Graphic.global_position = _start_gp.lerp(target_gp, _sticky_lerpval)
		$Graphic.scale = Vector2.ONE.lerp(target_scale, _sticky_lerpval)
	else:
		$Graphic.position = Vector2.ZERO
		$Graphic.scale = Vector2.ONE

func _stick_to_screen():
	if _lerp_tween:
		_lerp_tween.kill()
	_lerp_tween = create_tween()
	_lerp_tween.tween_property(self, "_sticky_lerpval", 1.0, 0.2)
	z_index = 9

func _release_from_screen():
	if _lerp_tween:
		_lerp_tween.kill()
	_lerp_tween = create_tween()
	_lerp_tween.tween_property(self, "_sticky_lerpval", 0.0, 0.2)
	z_index = -2

func take_me(character: BaseCharacter, dropped=false) -> bool:
	character.jump_to($JumpTo.global_position, func(): _spin_to_oblivion(character))
	return true

func handle_character(character: BaseCharacter):
	_spin_to_oblivion(character)

func _spin_to_oblivion(character: BaseCharacter):
	character.jump_to($JumpTo.global_position, func():
		var tween: Tween = character.ghostify_to_oblivion($Graphic/OblivionPoint)
		$Graphic/Shaker.add_trauma(0.5)
		change_inventory_count(character.get_type(), 1)
		_update_label()
		_current_timeout += summon_heal
		_prepare_timeout()
		tween.tween_callback(func():
			character.queue_free()
			)
		)
