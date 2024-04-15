class_name Skeleton
extends BaseCharacter

@export var eye_colors: Array[Color] = [Color.SKY_BLUE]

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_restyle()

func _restyle():
	var c = eye_colors.pick_random()
	$Graphic/Character/Face.self_modulate = c
	$Graphic/Character/Shocc.self_modulate = c

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)
	
func get_type():
	return Global.ResourceType.SKELETON
