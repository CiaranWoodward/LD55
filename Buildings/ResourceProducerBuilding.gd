class_name ResourceProducerBuilding
extends ProductionBuilding

func _get_output_type():
	pass
	
func do_build():
	super.do_build()
	change_inventory_count(_get_output_type(), 1)
	change_queue_count(_get_output_type(), 1)
	change_queue_count(Global.ResourceType.CAT, -1)

func handle_character(character: BaseCharacter):
	if (character is Cat):
		if (character.has_resource(Global.ResourceType.CAT)):
			character.give_resource(_get_output_type())
			change_inventory_count(_get_output_type(), -1)
			change_queue_count(_get_output_type(), -1)
