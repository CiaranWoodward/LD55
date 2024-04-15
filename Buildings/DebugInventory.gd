extends RichTextLabel

@onready var parent : Building = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var queue_counts = []
	var inventory_counts = []
	
	for resource in Global.ResourceType.values():
		var name = Global.ResourceType.keys()[resource]
		var queue_count = parent.get_queue_count(resource)
		var inventory_count = parent.get_inventory_count(resource)
		if queue_count != 0: queue_counts.push_back("{}: {}\n".format([name, queue_count], "{}"))
		if inventory_count != 0: inventory_counts.push_back("{}: {}\n".format([name, inventory_count], "{}"))
	
	text = "Transport: {}\nInventory:\n{}Queue:\n{}".format([parent.transport_count, "".join(inventory_counts), "".join(queue_counts)], "{}")
