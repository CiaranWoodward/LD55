class_name GameMap
extends Node2D

@onready var nav_region : NavigationRegion2D = $NavigationRegion2D
@onready var cursor : Cursor = $Cursor


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.game_map = self
	_compute_nav_mesh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _compute_nav_mesh():
	nav_region.bake_navigation_polygon()

func add_building_child(building: Building, position: Vector2):
	nav_region.add_child(building)
	building.global_position = position
	building.as_ui_part = false
	building.buy()
	_compute_nav_mesh()

func get_building_at_point(gcoords: Vector2):
	var dss = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.collision_mask = Global.PhysicsLayer.Building
	query.position = gcoords
	var shapes = dss.intersect_point(query)
	if shapes.size() > 0:
		for shape in shapes:
			var p = shape["collider"].get_parent()
			if p is Building:
				return p
	return null
