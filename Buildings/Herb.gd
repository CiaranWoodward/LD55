extends Node2D

func randomize_frame(animated_sprite: AnimatedSprite2D):
	animated_sprite.frame = randi_range(0, animated_sprite.sprite_frames.get_frame_count(animated_sprite.animation))
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sway.speed_scale = randf_range(0.4, 0.7)
	if randi_range(0, 1) == 1:
		$Herb.scale.x = -1
	$Herb.scale *= randf_range(0.2,0.4)
	randomize_frame($Herb/Herb)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
