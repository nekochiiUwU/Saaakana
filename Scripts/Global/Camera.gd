extends Camera2D

onready var Player1 = get_node("../../../Entities/Player 1/Player")
onready var Player2 = get_node("../../../Entities/Player 2/Player")
onready var UI = $UI
onready var P1Hp = $UI/P1/FontHp/Hp
onready var P1Q = $UI/P1/FontQ/Q
onready var P1W = $UI/P1/FontW/W
onready var P2Hp = $UI/P2/FontHp/Hp
onready var P2Q = $UI/P2/FontQ/Q
onready var P2W = $UI/P2/FontW/W

var Rotate = 0
var sensi = 0.3
var SmoothCamera = 2
var lastPos = Vector2()
var CameraPosition = Vector2()
var PlayerDistance = 0
var Zoom = [0.3, 0.3]
var lastZoom = 1
var UnZoom = 0

func get_imput(delta):
	if Input.is_action_pressed("Zoom [+]"):
		Zoom[0] -= delta + (Zoom[0] / 100)
		Zoom[1] -= delta + (Zoom[1] / 100)
	if Input.is_action_pressed("Zoom [-]"):
		Zoom[0] += delta + (Zoom[0] / 100)
		Zoom[1] += delta + (Zoom[1] / 100)
	if Input.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("Mouse Capture"):
		if Input.get_mouse_mode():
			Input.set_mouse_mode(0)
		else:
			Input.set_mouse_mode(2)

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
	if PlayerDistance < 100:
		PlayerDistance = 100
	zoom.x = ((Zoom[0] * (PlayerDistance / 100)) + lastZoom*2) / 3
	zoom.y = ((Zoom[1] * (PlayerDistance / 100)) + lastZoom*2) / 3
	UI.set_scale(zoom)
	
	position = (CameraPosition + lastPos * 10) / 11
	UI.set_position((position - lastPos) * 5)
	P1Hp.set_size(Vector2((Player1.Hp * 500) / Player1.MaxHp, 1))
	P1Q.set_size(Vector2(((((Player1.QCD - Player1.Q) / Player1.QCD) + (P1Q.get_size()[0]) / 136) / 2) * 136, 1))
	P1W.set_size(Vector2(((((Player1.WCD - Player1.W) / Player1.WCD) + (P1W.get_size()[0]) / 136) / 2) * 136, 1))
	P2Hp.set_size(Vector2((Player2.Hp * 500) / Player2.MaxHp, 2))
	P2Q.set_size(Vector2(((((Player2.QCD - Player2.Q) / Player2.QCD) + (P2Q.get_size()[0]) / 136) / 2) * 136, 2))
	P2W.set_size(Vector2(((((Player2.WCD - Player2.W) / Player2.WCD) + (P2W.get_size()[0]) / 136) / 2) * 136, 2))
	lastPos = position
	lastZoom = zoom.x
	rotation = Rotate
