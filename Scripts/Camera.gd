extends Camera2D

onready var Player1 = get_node("../../../Entities/Player 1")
onready var Player2 = get_node("../../../Entities/Player 2")
onready var UI = $UI
onready var P1Hp = $UI/P1/FontHp/Hp
onready var P1Auto = $UI/P1/FontAuto/Auto
var Rotate = 0
var sensi = 0.3
var SmoothCamera = 2
var lastPos = Vector2()
var CameraPosition = Vector2()
var PlayerDistance = 0
var Zoom = [1, 1]
var lastZoom = 1
var UnZoom = 0

func get_imput(delta):
	if Input.is_action_pressed("Zoom [+]"):
		Zoom[0] -= delta
		Zoom[1] -= delta
	if Input.is_action_pressed("Zoom [-]"):
		Zoom[0] += delta
		Zoom[1] += delta
	if Input.is_action_just_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("Mouse Capture"):
		if Input.get_mouse_mode():
			Input.set_mouse_mode(0)
		else:
			Input.set_mouse_mode(2)

"""
func _input(event):
	if event is InputEventMouseMotion:
		Rotate += deg2rad(event.relative.x * sensi)
"""

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	get_imput(delta)
	
	CameraPosition = (Player1.get_position() + Player2.get_position())/2
	
	PlayerDistance = CameraPosition - Player2.get_position()
	PlayerDistance.x *= 0.54545454
	if PlayerDistance.x < 0:
		PlayerDistance.x = -PlayerDistance.x
	if PlayerDistance.y < 0:
		PlayerDistance.y = -PlayerDistance.y
	if PlayerDistance.x > PlayerDistance.y:
		PlayerDistance = PlayerDistance.x
	else:
		PlayerDistance = PlayerDistance.y
	if PlayerDistance < 400:
		PlayerDistance = 400
	zoom.x = ((Zoom[0] * (PlayerDistance / 400)) + lastZoom*2) / 3
	zoom.y = ((Zoom[1] * (PlayerDistance / 400)) + lastZoom*2) / 3
	UI.set_scale(zoom)
	
	position = (CameraPosition + lastPos * 10) / 11
	UI.set_position((position - lastPos) * 5)
	""".rotated(-Rotate))"""
	P1Hp.set_size(Vector2(Player1.Hp * 4, 16))
	P1Auto.set_size(Vector2(Player1.Auto, 12))
	lastPos = position
	lastZoom = zoom.x
	rotation = Rotate
