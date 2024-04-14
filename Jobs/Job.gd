class_name Job
extends Node

signal on_complete
signal on_abort
signal on_finished

func complete():
	on_complete.emit()
	on_finished.emit()
	queue_free()
	
func abort():
	on_abort.emit()
	on_finished.emit()
	queue_free()
