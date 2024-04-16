class_name GameMap
extends Node2D

signal games_on_screen_changed(visible: bool)

@onready var nav_region : NavigationRegion2D = $NavigationRegion2D
@onready var cursor : Cursor = $Cursor

@export var enable_story = true

var _games_on_screen = false

func _enter_tree():
	Global.game_map = self

func _tick_story():
	await Story.tick_story($Hud/Dialogue)

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.game_map = self
	_compute_nav_mesh()
	$HappyMusic.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.camera.visible_rect().has_point($GameFollowPoint.global_position):
		if !_games_on_screen:
			_games_on_screen = true
			games_on_screen_changed.emit(_games_on_screen)
	else:
		if _games_on_screen:
			_games_on_screen = false
			games_on_screen_changed.emit(_games_on_screen)
	
	if(enable_story): await _tick_story()
	
func _compute_nav_mesh():
	nav_region.bake_navigation_polygon()

func get_portal():
	return $NavigationRegion2D/Portal

func get_starbox():
	return $Hud/Starbox

func add_building_child(building: Building, position: Vector2):
	nav_region.add_child(building)
	building.global_position = position
	building.as_ui_part = false
	building.buy()
	_compute_nav_mesh()

func add_character(character: BaseCharacter):
	if is_instance_valid(character.get_parent()):
		character.reparent(nav_region)
	else:
		nav_region.add_child(character)

func get_building_at_point(gcoords: Vector2):
	var dss = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.collision_mask = Global.PhysicsLayer.BUILDING
	query.position = gcoords
	var shapes = dss.intersect_point(query)
	if shapes.size() > 0:
		for shape in shapes:
			var p = shape["collider"].get_parent()
			if p is Building:
				return p
	return null
