extends MarginContainer

@export var building_type : Global.BuildingType

@onready var target_building = Global.get_building(building_type)

# Called when the node enters the scene tree for the first time.
func _ready():
	$ARContainer/Button/Label.text = Global.get_building_name(building_type)
	$ARContainer/Button/Star/Cost.text = "%d" % target_building.cost
	print("%s: %d" % [Global.get_building_name(building_type), target_building.cost])
	Global.resource_updated.connect(_resources_updated)
	Global.unlocked.connect(_resources_updated)
	_resources_updated()
	
	match building_type:
		Global.BuildingType.RECUTEMENT_CENTRE:
			$ARContainer/Button/SizeRef/RecutementCentre.visible = true
		Global.BuildingType.SHEEP_FARM:
			$ARContainer/Button/SizeRef/Barn.visible = true
		Global.BuildingType.GRANARY:
			$ARContainer/Button/SizeRef/CornField.visible = true
		Global.BuildingType.NURSING_HOME:
			$ARContainer/Button/SizeRef/NursingHome.visible = true
		Global.BuildingType.FISH_POND:
			$ARContainer/Button/SizeRef/Fishery.visible = true
		Global.BuildingType.HOLDING_PEN_SHEEP, Global.BuildingType.HOLDING_PEN_GRAN, Global.BuildingType.HOLDING_PEN_LOST_SOUL:
			$ARContainer/Button/SizeRef/HoldingPen.visible = true
		Global.BuildingType.FIELD_HOSPITAL:
			$ARContainer/Button/SizeRef/FieldHospital.visible = true
		Global.BuildingType.HERB_GARDEN:
			$ARContainer/Button/SizeRef/HerbGarden.visible = true

func _resources_updated():
	visible = target_building.is_cost_affordable() && Global.is_building_unlocked(building_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	Global.cursor.set_building(Global.get_building(building_type))
