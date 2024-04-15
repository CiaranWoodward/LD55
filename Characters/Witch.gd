class_name Witch
extends BaseCharacter

@export var skin_colors: Array[Color] = [Color.BISQUE]
@export var hair_colors: Array[Color] = [Color.CORAL]
@export var clothes_colors: Array[Color] = [Color.SKY_BLUE]
@export var eye_colors: Array[Color] = [Color.SKY_BLUE]

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_restyle()

func _restyle():
	$Graphic/Character/Skin.self_modulate = skin_colors.pick_random()
	$Graphic/Character/Hair.self_modulate = hair_colors.pick_random()
	$Graphic/Character/Eyes.self_modulate = eye_colors.pick_random()
	var c = clothes_colors.pick_random()
	$Graphic/Character/Hat.self_modulate = c
	$Graphic/Character/Dress.self_modulate = c

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)

func get_type():
	return Global.ResourceType.WITCH
