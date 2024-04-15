class_name Sheep
extends BaseCharacter

@export var skin_colors: Array[Color] = [Color.BISQUE]
@export var wool_colors: Array[Color] = [Color.CORAL]
@export var eye_colors: Array[Color] = [Color.SKY_BLUE]

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_restyle()

func _restyle():
	var c = skin_colors.pick_random()
	$Graphic/Character/Skin.self_modulate = c
	c = wool_colors.pick_random()
	$Graphic/Character/Wool.self_modulate = c
	c = eye_colors.pick_random()
	$Graphic/Character/Eyes.self_modulate = c
	$Graphic/Character/Shocc.self_modulate = c

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)
	
func get_type():
	return Global.ResourceType.SHEEP
