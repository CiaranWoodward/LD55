extends Sprite2D

@onready var rotation_speed = randf_range(-0.1, 0.1)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position += Vector2(randf_range(-100, 100), randf_range(-100, 100))
	var tween = create_tween()
	modulate = Color.GOLD
	modulate.a = 0
	tween.tween_property(self, "modulate", Color.GOLD, 0.05)
	tween.parallel().tween_property(self, "global_position", Global.game_map.get_portal().global_position, randf_range(0.4, 0.6)).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(func():
		Global.change_resource_count(Global.ResourceType.GOLD, 1)
		visible = false
		queue_free()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += delta * rotation_speed
