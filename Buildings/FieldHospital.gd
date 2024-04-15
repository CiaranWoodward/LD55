extends CharacterProducerBuilding

func _get_input_type():
	return Global.ResourceType.HERB

func _create_character() -> BaseCharacter:
	return load("res://Characters/LostSoul.tscn").instantiate()
