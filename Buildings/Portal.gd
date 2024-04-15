class_name Portal
extends Building

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_me(character: BaseCharacter, dropped=false) -> bool:
	var tween = character.ghostify_to_oblivion($Graphic/OblivionPoint)
	tween.tween_callback(func():
		_exchange(character)
		character.queue_free()
		)
	$Graphic/WibbleBase/WibbleBaseAction.play("Produce")
	return true

func _exchange(character: BaseCharacter):
	var spawn
	if character is Granny:
		spawn = load("res://Characters/Witch.tscn").instantiate()
	elif character is Sheep:
		spawn = load("res://Characters/Demon.tscn").instantiate()
	else:
		return
	Global.game_map.add_character(spawn)
	spawn.global_position = $Graphic/SpawnPoint.global_position
	spawn.jump_to($Graphic/RelayPoint.global_position, func():pass)
