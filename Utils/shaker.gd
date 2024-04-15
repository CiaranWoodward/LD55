extends Node2D

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(40, 40)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

@onready var start_position = position
@onready var noise = FastNoiseLite.new()
var noise_y = 0

var childhood_trauma = 0.0 # Base level of trauma
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var offset: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.frequency = 0.15
	noise.fractal_octaves = 2

func add_permanant_trauma(amount: float):
	childhood_trauma = min(childhood_trauma + amount, 0.6)

func add_trauma(amount : float):
	trauma = min(trauma + amount, 1.0)

func _shake(): 
	var working_trauma = min(trauma + childhood_trauma, 1.0)
	var amt = pow(working_trauma, trauma_power)
	print(amt)
	noise_y += 1
	rotation = max_roll * amt * noise.get_noise_2d(0,noise_y)
	offset.x = max_offset.x * amt * noise.get_noise_2d(1000,noise_y)
	offset.y = max_offset.y * amt * noise.get_noise_2d(2000,noise_y)
	position = start_position + offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma or childhood_trauma:
		trauma = max(trauma - decay * delta, 0)
		_shake()
	elif position != start_position or rotation != 0:
		position = start_position
		rotation = 0.0
