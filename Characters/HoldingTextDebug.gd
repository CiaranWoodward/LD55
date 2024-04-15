extends RichTextLabel

@onready var parent : Cat = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(parent._inventory): text = Global.ResourceType.keys()[parent._inventory]
	else: text = ""
