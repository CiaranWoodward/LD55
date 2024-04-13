extends Camera2D

@export var MAX_SPEED = 1000.0
@export var ACCEL_TIME = 0.5
@export var STOP_TIME = 0.2
@export var ZOOM_AMOUNT = 0.2
@export var ZOOM_TIME = 0.15
@export var ZOOM_MIN = 0.6
@export var ZOOM_MAX = 2

var zoom_tween
var move_tween
var dir_tween

var speed = 0
var target_zoom = Vector2(1, 1)
var dir_vec = Vector2.ZERO
var moving = false
var dragging = false
var rezoom = false

## Maximum camera position
@export var MaxPos : Vector2 = Vector2(1000, 1000)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _unhandled_input(event):
	# Only allow unhandled input for start drag
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_RIGHT || event.button_index == MOUSE_BUTTON_MIDDLE):
		if event.is_pressed():
			dragging = true
			dir_tween = null
			move_tween = null
			speed = 0
			moving = false
			dir_vec = Vector2.ZERO
	if event.is_action_pressed("zoom_in"):
		target_zoom -= Vector2(ZOOM_AMOUNT, ZOOM_AMOUNT)
		rezoom = true
	if event.is_action_pressed("zoom_out"):
		target_zoom += Vector2(ZOOM_AMOUNT, ZOOM_AMOUNT)
		rezoom = true

func _input(event):
	# Once we have started dragging, always track the input
	if not dragging:
		return
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_RIGHT || event.button_index == MOUSE_BUTTON_MIDDLE):
		if not event.is_pressed():
			dragging = false
	if dragging && event is InputEventMouseMotion:
		position -= event.relative / zoom.x
		_bound_level()

func _bound_level():
	if position.x < -MaxPos.x:
		position.x = -MaxPos.x
	if position.y < -MaxPos.y:
		position.y = -MaxPos.y
	if position.x > MaxPos.x:
		position.x = MaxPos.x
	if position.y > MaxPos.y:
		position.y = MaxPos.y

func _physics_process(delta):
	if rezoom:
		if target_zoom.x > ZOOM_MAX:
			target_zoom = Vector2(ZOOM_MAX, ZOOM_MAX)
		if target_zoom.x < ZOOM_MIN:
			target_zoom = Vector2(ZOOM_MIN, ZOOM_MIN)
		if target_zoom != zoom:
			zoom_tween = create_tween()
			zoom_tween.tween_property(self, "zoom", target_zoom, ZOOM_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		rezoom = false
	
	if dragging:
		return
	
	var dir_delta = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		dir_delta.x += 1
	if Input.is_action_pressed("ui_left"):
		dir_delta.x -= 1
	if Input.is_action_pressed("ui_up"):
		dir_delta.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir_delta.y += 1
	if speed == 0:
		dir_vec = dir_delta
	if dir_delta != Vector2.ZERO:
		dir_delta = dir_delta.normalized()
		dir_tween = create_tween()
		dir_tween.tween_property(self, "dir_vec", dir_delta, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	if dir_delta != Vector2.ZERO && !moving:
		# just started moving
		move_tween = create_tween()
		move_tween.tween_property(self, "speed", MAX_SPEED, ACCEL_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		moving = true
	elif dir_delta == Vector2.ZERO && moving:
		# just stopped moving
		move_tween = create_tween()
		move_tween.tween_property(self, "speed", 0, STOP_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		moving = false
	
	position += dir_vec * speed * delta * zoom.x
	_bound_level()
