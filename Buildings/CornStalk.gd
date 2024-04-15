extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sway.speed_scale = randf_range(0.4, 0.6)
	if randi_range(0, 1) == 1:
		$Corn.scale.x = -1
	$Corn.scale *= randf_range(0.9, 1.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
