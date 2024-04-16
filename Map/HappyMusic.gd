extends AudioStreamPlayer

var is_loud = true
var fade_tween

# Called when the node enters the scene tree for the first time.
func _ready():
	play()

func fade_in():
	if !is_loud:
		is_loud = true
		if fade_tween:
			fade_tween.kill()
		fade_tween = create_tween()
		fade_tween.tween_property(self, "volume_db", 0, 1)

func fade_out():
	if is_loud:
		is_loud = false
		if fade_tween:
			fade_tween.kill()
		fade_tween = create_tween()
		fade_tween.tween_property(self, "volume_db", -80, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().get_nodes_in_group("characters").filter(func(c): return c is Bug).size() >= 1:
		fade_out()
	else:
		fade_in()
