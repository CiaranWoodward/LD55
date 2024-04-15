class_name LostSoul
extends HoldableCharacter

@export var body_colors: Array[Color] = [Color.BISQUE]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Graphic/Glow.speed_scale = randf_range(0.3, 0.6)
	$Graphic/Character/Body.speed_scale = randf_range(0.9, 1.1)
	super._ready()
	_restyle()

func _restyle():
	$Graphic/Character/Body.self_modulate = body_colors.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)

func get_type():
	return Global.ResourceType.LOST_SOUL
