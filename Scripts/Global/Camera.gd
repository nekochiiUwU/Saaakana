extends Camera2D

onready var Player1 = get_node("../../../Entities/Player 1/Player")
onready var Player2 = get_node("../../../Entities/Player 2/Player")

onready var _NotificationBar = preload("res://Scenes/Global/NotificationBar.tscn")
onready var _NotificationText = preload("res://Scenes/Global/NotificationText.tscn")

onready var UI = $UI
onready var P1Hp = $UI/P1/FontHp/Hp
onready var P1Q = $UI/P1/FontQ/Q
onready var P1W = $UI/P1/FontW/W
onready var P1E = $UI/P1/FontE/E
onready var P1R = $UI/P1/FontR/R
onready var P2Hp = $UI/P2/FontHp/Hp
onready var P2Q = $UI/P2/FontQ/Q
onready var P2W = $UI/P2/FontW/W
onready var P2E = $UI/P2/FontE/E
onready var P2R = $UI/P2/FontR/R

onready var Effects = $UI/Effects

var Rotate = 0
var sensi = 0.3
var SmoothCamera = 2
var lastPos = Vector2()
var CameraPosition = Vector2()
var PlayerDistance = 0
var Zoom = [0.3, 0.3]
var lastZoom = 1
var UnZoom = 0
var Notifications =  {
	"General": [], 
	"Player 1": [], 
	"Player 2": [],
	"Displayed": []}
	
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
	if Input.is_action_just_pressed("Mouse Capture"):
		Effects.environment.glow_enabled = not Effects.environment.glow_enabled

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	DisplayNotifications()
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
	UI.set_position((position - lastPos) * 2)
	P1Hp.set_size(Vector2((Player1.Hp * 500) / Player1.MaxHp, 1))
	
	P1Q.set_size(Vector2(((((Player1.QCD - Player1.Q) / Player1.QCD) + (P1Q.get_size()[0]) / 136) / 2) * 136, 1))
	if Player1.Q <= 0:
		P1Q.get_parent().self_modulate = Color(0.8, 0.8, 0.8, 0.5)
	else:
		P1Q.get_parent().self_modulate = Color(0.2, 0.2, 0.2, 0.2)
	
	P1W.set_size(Vector2(((((Player1.WCD - Player1.W) / Player1.WCD) + (P1W.get_size()[0]) / 136) / 2) * 136, 1))
	if Player1.W <= 0:
		P1W.get_parent().self_modulate = Color(0.8, 0.8, 0.8, 0.5)
	else:
		P1W.get_parent().self_modulate = Color(0.2, 0.2, 0.2, 0.2)
	
	P1E.set_size(Vector2(((((Player1.ECD - Player1.E) / Player1.ECD) + (P1E.get_size()[0]) / 136) / 2) * 136, 1))
	if Player1.E <= 0:
		P1E.get_parent().self_modulate = Color(0.8, 0.8, 0.8, 0.5)
	else:
		P1E.get_parent().self_modulate = Color(0.2, 0.2, 0.2, 0.2)
	
	P1R.set_size(Vector2(((((Player1.RCD - Player1.R) / Player1.RCD) + (P1R.get_size()[0]) / 136) / 2) * 136, 1))
	if Player1.R <= 0:
		P1R.get_parent().self_modulate = Color(0.8, 0.8, 0.8, 0.5)
	else:
		P1R.get_parent().self_modulate = Color(0.2, 0.2, 0.2, 0.2)
	
	P2Hp.set_size(Vector2((Player2.Hp * 500) / Player2.MaxHp, 1))
	
	P2Q.set_size(Vector2(((((Player2.QCD - Player2.Q) / Player2.QCD) + (P2Q.get_size()[0]) / 136) / 2) * 136, 1))
	if Player2.Q <= 0:
		P2Q.get_parent().self_modulate = Color(0.8, 0.8, 0.8, 0.5)
	else:
		P2Q.get_parent().self_modulate = Color(0.2, 0.2, 0.2, 0.2)
	
	P2W.set_size(Vector2(((((Player2.WCD - Player2.W) / Player2.WCD) + (P2W.get_size()[0]) / 136) / 2) * 136, 1))
	if Player2.W <= 0:
		P2W.get_parent().self_modulate = Color(0.8, 0.8, 0.8, 0.5)
	else:
		P2W.get_parent().self_modulate = Color(0.2, 0.2, 0.2, 0.2)
	
	P2E.set_size(Vector2(((((Player2.ECD - Player2.E) / Player2.ECD) + (P2E.get_size()[0]) / 136) / 2) * 136, 1))
	if Player2.E <= 0:
		P2E.get_parent().self_modulate = Color(0.8, 0.8, 0.8, 0.5)
	else:
		P2E.get_parent().self_modulate = Color(0.2, 0.2, 0.2, 0.2)
	
	P2R.set_size(Vector2(((((Player2.RCD - Player2.R) / Player2.RCD) + (P2R.get_size()[0]) / 136) / 2) * 136, 1))
	if Player2.R <= 0:
		P2R.get_parent().self_modulate = Color(0.8, 0.8, 0.8, 0.5)
	else:
		P2R.get_parent().self_modulate = Color(0.2, 0.2, 0.2, 0.2)
	
	lastPos = position
	lastZoom = zoom.x
	rotation = Rotate

func NewNotification(Type = "Bar", Name = "Name", Value = 50, MaxValue = 100, Emplacement = "General", Time = 1):
	Notifications[Emplacement].append([Type, Name, Value, MaxValue, Time, false])

func DisplayNotifications():
	for Notif in Notifications["Player 1"]:
		if Notif[5]:
			Notif[5].Replace(Vector2(0, 64 + 32 * Notifications["Player 1"].find(Notif)))
			if Notif[5].Time <= 0:
				Notif[5].Kill()
				Notifications["Player 1"].erase(Notif)
		else:
			if Notif[0] == "Bar":
				Notif[5] = _NotificationBar.instance()
				P1Hp.add_child(Notif[5])
				Notif[5].Pop(Notif[1], Notif[2], Notif[3], Notif[4], Vector2(0, 64 + 32 * len(Notifications["Player 1"])))

	for Notif in Notifications["Player 2"]:
		if Notif[5]:
			Notif[5].Replace(Vector2(0, 64 + 32 * Notifications["Player 2"].find(Notif)))
			if Notif[5].Time <= 0:
				Notif[5].Kill()
				Notifications["Player 2"].erase(Notif)
		else:
			if Notif[0] == "Bar":
				Notif[5] = _NotificationBar.instance()
				P2Hp.add_child(Notif[5])
				Notif[5].Pop(Notif[1], Notif[2], Notif[3], Notif[4], Vector2(0, 64 + 32 * len(Notifications["Player 2"])))
