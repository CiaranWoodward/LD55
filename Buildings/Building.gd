class_name Building
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("buildings")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass	

func do_you_want_me(character: BaseCharacter) -> bool:
	return false

func take_me(character: BaseCharacter, dropped=false) -> bool:
	return false

func distance_squared_to_me(character: BaseCharacter):
	return character.global_position.distance_squared_to(global_position)
