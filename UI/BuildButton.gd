extends MarginContainer

@export var building_type : Global.BuildingType

@onready var target_building = Global.get_building_class(building_type).instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	$ARContainer/Button/Label.text = Global.get_building_name(building_type)
	Global.resource_updated.connect(_resources_updated)
	_resources_updated()

func _resources_updated():
	visible = target_building.is_cost_affordable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	Global.cursor.set_building(Global.get_building_class(building_type).instantiate())
