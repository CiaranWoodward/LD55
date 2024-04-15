extends CharacterProducerBuilding

func _get_input_type():
	return Global.ResourceType.CORN

func _create_character() -> BaseCharacter:
	return load("res://Characters/Granny.tscn").instantiate()
