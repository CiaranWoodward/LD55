extends CharacterProducerBuilding

func _get_input_type():
	return Global.ResourceType.FISH

func _create_character() -> BaseCharacter:
	return load("res://Characters/Cat.tscn").instantiate()
