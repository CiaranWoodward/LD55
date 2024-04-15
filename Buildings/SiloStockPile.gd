extends Node2D

var type : Global.ResourceType = Global.ResourceType.CORN

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_fullness(current, max):
	if current == 0:
		$Scaler.visible = false
	else:
		$Scaler.visible = true
	
	var prop = float(current)/float(max)
	$Scaler/BarTile.position.y = lerp(113, -122, prop)
	$Scaler/BarTile.size.y = lerp(0, 230, prop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
