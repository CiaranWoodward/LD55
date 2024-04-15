class_name ResourceProducerBuilding
extends ProductionBuilding

func _get_output_type():
	pass
	
func do_build():
	if (is_job_blocked()): return
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

func is_job_blocked() -> bool:
	return super.is_job_blocked() or get_inventory_count(_get_output_type()) >= max_inventory
