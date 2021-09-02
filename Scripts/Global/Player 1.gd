extends KinematicBody2D

onready var _QSpell = preload("res://Scenes/Personnages/Archer/Q.tscn")
onready var _WSpell = preload("res://Scenes/Personnages/Archer/W.tscn")
onready var Frame = $Frame

var Hp = 1000
var MaxHp = 1000

var Q = 0
var QCD = 20
var QCast = 5
var QDamage = 50
var QShootRelease = 0
var QShoot = false
var QOnClick = false

var W = 0
var WCD = 600
var WCD1 = 0
var WCD2 = 30
var WCDState = 120
var WCast = 2
var WState = 0
var WDamage = 50
var WShootRelease = 0
var WDash = false
var WShoot = false
var WOnClick = false

var E = 0
var ECD = 100
var ECast = 5
var ELoad = 0
var EArrow = 0
var EMaxLoad = 45
var EDamage = 100
var EShootRelease = 0
var EShoot = false
var EOnClick = false

var R = 0
var RCD = 100
var RCast = 5
var RDamage = 50
var RShootRelease = 0
var RShoot = false
var ROnClick = false

var Stunn = 0
var Scripted = 0

var speed = 3
var speedtick = speed

var sensi = 2
var rotationSensi = 128
var Rotate = 0
var rotationFactor = 0
var collision_info = 0
var velocity = Vector2()
var Scriptedvelocity = Vector2()
var MovementRight = false
var MovementLeft = false
var MovementDown = false
var MovementUp = false
var ScriptedAction = ""
var DashSpeed = 0
""" ===0=== """

func SelectAnim():
	if QShoot or WShoot or EShoot:
		Frame.animation = "Tir"
	elif QShootRelease or WShootRelease:
		Frame.animation = "Release"
		QShootRelease -= 1
	elif ScriptedAction == "Dash":
		Frame.animation = "Dash"
	elif MovementDown and not MovementRight and not MovementLeft:
		Frame.animation = "Walk Right"
	elif MovementUp and not MovementRight and not MovementLeft:
		Frame.animation = "Walk Right"
	elif MovementRight and not MovementDown and not MovementUp:
		Frame.animation = "Walk Right"
	elif MovementLeft and not MovementDown and not MovementUp:
		Frame.animation = "Walk Right"
	elif MovementDown and MovementLeft and not MovementRight and not MovementUp:
		Frame.animation = "Walk Right"
	elif MovementUp and MovementRight and not MovementLeft and not MovementDown:
		Frame.animation = "Walk Right"
	elif MovementRight and MovementDown and not MovementLeft and not MovementUp:
		Frame.animation = "Walk Right"
	elif MovementLeft and MovementUp and not MovementRight and not MovementDown:
		Frame.animation = "Walk Right"
	else:
		Frame.animation = "Stand"

	while rotation_degrees > 180:
		rotation_degrees -= 360
	while rotation_degrees < -180:
		rotation_degrees += 360

	if -90 < rotation_degrees and rotation_degrees < 90:
		Frame.flip_v = false
	else:
		Frame.flip_v = true

""" ===0=== """

func Movements(delta):
	velocity = (velocity.normalized() * speedtick) * (delta * 60)
	velocity = move_and_collide(velocity)
	velocity = Vector2()

""""" ===0=== """

func get_input(delta):
	MovementRight = false
	MovementLeft = false
	MovementDown = false
	MovementUp = false
	if Input.is_action_pressed("Move Right"):
		velocity.x += 1
		MovementRight = true
	if Input.is_action_pressed("Move Left"):
		velocity.x -= 1
		MovementLeft = true
	if Input.is_action_pressed("Move Down"):
		velocity.y += 1
		MovementDown = true
	if Input.is_action_pressed("Move Up"):
		velocity.y -= 1
		MovementUp = true
	if MovementRight and MovementLeft:
		MovementRight = false
		MovementLeft = false
	if MovementDown and MovementUp:
		MovementDown = false
		MovementUp = false
		
	if Input.is_action_pressed("Rotation +"):
		rotation_degrees += rotationSensi * delta
	if Input.is_action_pressed("Rotation -"):
		rotation_degrees -= rotationSensi * delta

	if Input.is_action_pressed("Spell0"):
		if not QOnClick and not Q > 0:
			if QCast:
				QCast -= 1
				QShoot = true
				speedtick /= 3
			else:
				var QSpell = _QSpell.instance()
				get_parent().add_child(QSpell)
				QSpell.Launch(Vector2(position.x + 8, position.y - 8), rotation_degrees, QDamage, 0b11100000000000000000)
				QOnClick = true
				QShoot = false
				QShootRelease = 5
				Q = QCD
	else:
		QCast = 7
		QShoot = false
		QOnClick = false
	if Input.is_action_pressed("Spell1"):
		if not WOnClick and not W > 0:
			if WState <= 0:
				if WCast:
					WCast -= 1
					WShoot = true
					speedtick /= 3
				else:
					var WSpell = _WSpell.instance()
					get_parent().add_child(WSpell)
					WSpell.Launch(Vector2(position.x + 8, position.y - 8), rotation_degrees, QDamage, 0b11100000000000000000)
					WOnClick = true
					WShoot = false
					WShootRelease = 5
					W = WCD
					WState = WCDState
			else:
				Scriptedvelocity = Vector2()
				ScriptedAction = "Dash"
				Scripted = 10
				DashSpeed = 10
				if Input.is_action_pressed("Move Right"):
					Scriptedvelocity.x = 1
				if Input.is_action_pressed("Move Left"):
					Scriptedvelocity.x -= 1
				if Input.is_action_pressed("Move Down"):
					Scriptedvelocity.y += 1
				if Input.is_action_pressed("Move Up"):
					Scriptedvelocity.y -= 1
				WState = 0
				W = WCD2
	else:
		WCast = 2
		WShoot = false
		WOnClick = false
	if Input.is_action_pressed("Spell2"):
		if not EOnClick and not W > 0:
			ELoad = 1
			EShoot = true
			EOnClick = true
		else:
			if ELoad:
				ELoad += delta * 60
				if ELoad > EMaxLoad:
					EArrow += 1
					ELoad = 1
				E = ECD
				EShootRelease = 5
				speedtick /= 4
				
	else:
		if ELoad:
			for item in range(EArrow):
				var ESpell = _QSpell.instance()
				get_parent().add_child(ESpell)
				ESpell.Launch(Vector2(position.x + 8, position.y - 8), rotation_degrees + rand_range(-(EMaxLoad - ELoad) / 2, -(EMaxLoad - ELoad) / 2), EDamage, 0b11100000000000000000)
		ELoad = 0
		ECast = 0
		EShoot = false
		EOnClick = false

func Cooldown(delta):
	if Q > 0:
		Q -= (delta * 60)
	if W > 0:
		W -= (delta * 60)
	if WState > 0:
		WState -= (delta * 60)
	if Stunn:
		Stunn -= (delta * 60)
	if Scripted:
		Scripted -= (delta * 60)

func ScriptAction(delta):
	if ScriptedAction == "Dash":
		velocity = move_and_collide(Scriptedvelocity.normalized() * (delta * 60) * DashSpeed)
		velocity = Vector2()

""" ===0=== """

func _ready():
	""""""

func _process(delta):
	speedtick = speed
	Cooldown(delta)
	if Stunn > 0 or Scripted > 0:
		ScriptAction(delta)
	else:
		ScriptedAction = ""
		get_input(delta)
		Movements(delta)
	SelectAnim()
