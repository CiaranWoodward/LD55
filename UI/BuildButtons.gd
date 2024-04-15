extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var bb = load("res://UI/BuildButton.tscn")
	for val in Global.BuildingType.values():
		if val == Global.BuildingType.PORTAL:
			continue
		var b = bb.instantiate()
		b.building_type = val
		add_child(b)
