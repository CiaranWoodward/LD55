class_name BaseCharacter
extends CharacterBody2D

@export var movement_speed: float = 100
@export var acceleration: float = 7

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready():
	pass
	
func goto(type: Global.BuildingType):
	var target_position: Vector2 = Global.game_map.get_node("Portal").global_position
	nav.target_position = target_position

func _physics_process(delta):	
	var direction = Vector3();
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * movement_speed, acceleration * delta)
	
	move_and_slide()
	
	
