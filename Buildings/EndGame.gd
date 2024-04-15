extends Building

var _sticky_lerpval = 0.0
var _start_gp: Vector2
var _lerp_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_start_gp = $Graphic.global_position
	Global.game_map.games_on_screen_changed.connect(_updated_onscreen)
	_stick_to_screen()
	change_queue_count(Global.ResourceType.WITCH, -5)

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
		tween.tween_callback(func():
			character.queue_free()
			)
		)
