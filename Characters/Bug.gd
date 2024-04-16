class_name Bug
extends BaseCharacter

@export var eye_colors: Array[Color] = [Color.BISQUE]

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_restyle()
	make_angry()
	Global.bug_count += 1

func _restyle():
	$Graphic/Character/Eyes.self_modulate = eye_colors.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)

func get_type():
	return Global.ResourceType.BUG
