class_name Demon
extends BaseCharacter

@export var skin_colors: Array[Color] = [Color.BISQUE]
@export var hair_colors: Array[Color] = [Color.CORAL]
@export var horn_colors: Array[Color] = [Color.SKY_BLUE]
@export var eye_colors: Array[Color] = [Color.SKY_BLUE]

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_restyle()

func _restyle():
	$Graphic/Character/Skin.self_modulate = skin_colors.pick_random()
	$Graphic/Character/Fur.self_modulate = hair_colors.pick_random()
	$Graphic/Character/Horns.self_modulate = horn_colors.pick_random()
	$Graphic/Character/Body.self_modulate = eye_colors.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)

func get_type():
	return Global.ResourceType.DEMON
