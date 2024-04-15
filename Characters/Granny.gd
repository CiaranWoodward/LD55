class_name Granny
extends HoldableCharacter

@export var skin_colors: Array[Color] = [Color.BISQUE]
@export var hair_colors: Array[Color] = [Color.CORAL]
@export var skirt_colors: Array[Color] = [Color.SKY_BLUE]
@export var cardi_colors: Array[Color] = [Color.SKY_BLUE]
@export var top_colors: Array[Color] = [Color.SKY_BLUE]

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_restyle()

func _restyle():
	$Graphic/Character/Skin.self_modulate = skin_colors.pick_random()
	$Graphic/Character/Hair.self_modulate = hair_colors.pick_random()
	$Graphic/Character/Skirt.self_modulate = skirt_colors.pick_random()
	$Graphic/Character/Cardi.self_modulate = cardi_colors.pick_random()
	$Graphic/Character/Top.self_modulate = top_colors.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)

func get_type():
	return Global.ResourceType.GRANNY
