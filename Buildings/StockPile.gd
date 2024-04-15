extends Node2D

@export var type : Global.ResourceType = Global.ResourceType.CORN

var _node_of_interest: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		Global.ResourceType.CORN:
			_node_of_interest = $StockPile/Corn
		Global.ResourceType.FISH:
			_node_of_interest = $StockPile/Fish
		Global.ResourceType.HERB:
			_node_of_interest = $StockPile/Herb
		_:
			assert(false)

func set_fullness(current, max):
	if current == 0:
		_node_of_interest.visible = false
	else:
		_node_of_interest.visible = true
	
	var prop = float(current)/float(max)
	if prop <= 0.25:
		_node_of_interest.frame = 0
	elif prop <= 0.5:
		_node_of_interest.frame = 1
	elif prop <= 0.75:
		_node_of_interest.frame = 2
	else:
		_node_of_interest.frame = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
