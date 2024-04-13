class_name Portal
extends Building

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func do_you_want_me(character: BaseCharacter) -> bool:
	return true

func take_me(character: BaseCharacter) -> bool:
	character.queue_free()
	$Graphic/WibbleBase/WibbleBaseAction.play("Produce")
	return true

