extends KinematicBody2D
onready var Camera = get_node("../../../World/Cameras/Camera")
onready var Player2 = get_node("../../Player 2/Player")
onready var _QSpell = preload("res://Scenes/Personnages/Archer/Q.tscn")
onready var _WSpell = preload("res://Scenes/Personnages/Archer/W.tscn")
onready var _ESpell = preload("res://Scenes/Personnages/Archer/E.tscn")
onready var _RSpell = preload("res://Scenes/Personnages/Archer/R.tscn")
onready var Frame = $Frame

var Hp = 1000
var MaxHp = 1000
var Death = false

var Q = 0
var QCD = 20
var QCast = 7
var QDamage = 50
var QShootRelease = 0
var QShoot = false
var QOnClick = false

var W = 0
var WCD = 600
var WCD1 = 0
var WCD2 = 0
var WCast = 0
var WState = 0
var WDamage = 50
var WShootRelease = 0
var WDash = false
var WShoot = false
var WOnClick = false

var E = 0
var ECD = 480
var ECast = 10
var ELoad = 0
var EArrow = 0
var EMaxLoad = 30
var EDamage = 75
var EShootRelease = 0
var EShoot = false
var EOnClick = false

var R = 0
var RCD = 420
var RCast = 5
var RPrecision = 100
var RDamage = 125
var RShootRelease = 0
var RShoot = false
var ROnClick = false

var Stunn = 0
var Scripted = 0

var speed = 3
var speedtick = speed

var ModulateReset = -1

var sensi = 3
var rotationSensi = 87
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

func SelectAnim(delta):
	if Death:
		Frame.animation = "Ded"
		
	elif QShoot or WShoot:
		Frame.animation = "Tir"
		
	elif 0 < EShootRelease:
		Frame.animation = "Release"
		EShootRelease -= (delta * 60)
		
	elif EShoot:
		Frame.animation = "Tir"
	
	elif 0 < QShootRelease or 0 < WShootRelease or 0 < RShootRelease:
		Frame.animation = "Release"
		QShootRelease -= (delta * 60)
		WShootRelease -= (delta * 60)
		RShootRelease -= (delta * 60)
		
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
	velocity = move_and_collide(velocity.normalized() * delta * 60 * speedtick)
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
	if Input.is_action_just_pressed("Lock"):
		var Player2pos = Player2.get_position()
		rotation = -atan2(Player2pos.x - position.x, Player2pos.y - position.y) + PI/2
		RPrecision = 300
		if WState == -1 or WState == 1:
			W = WCD
			WState = 0

	if Input.is_action_pressed("Spell0"):
		if not QOnClick and not Q > 0:
			if QCast:
				QCast -= 1
				QShoot = true
				speedtick /= 3
			else:
				var QSpell = _QSpell.instance()
				get_parent().add_child(QSpell)
				QSpell.Launch(Vector2(position.x + 8, position.y - 12), rotation_degrees, QDamage, 0b11100000000000000000)
				QSpell.NodeAnimation.self_modulate =  Color(0.9, 0.9, 1.1)
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
					WSpell.Launch(Vector2(position.x + 8, position.y - 12), rotation_degrees, QDamage, 0b11100000000000000000)
					WSpell.modulate = Color(0.8, 0.8, 1)
					WOnClick = true
					WShoot = false
					WShootRelease = 5
					W = WCD
					WState = -2
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
				WState = -1
				W = WCD2
	else:
		WCast = 2
		WShoot = false
		WOnClick = false
	if Input.is_action_pressed("Spell2"):
		if not EOnClick and not E > 0:
			ELoad = 1
			EArrow = 1
			EOnClick = true
			EShoot = true
		else:
			if not E > 0 and EArrow:
				Camera.NewNotification("Bar", "E " + str(EArrow) + "- Dispertion", EMaxLoad - ELoad, EMaxLoad, "Player 1", 1)
				speedtick /= 3
				if ELoad and not EArrow > 3:
					if ELoad >= EMaxLoad and not EArrow > 2:
						EArrow += 1
						ELoad = 1
					else:
						if not EArrow > 2 or not ELoad >= EMaxLoad:
							ELoad += delta * 60
						else:
							ELoad = EMaxLoad
							EArrow = 3
				
	else:
		if ELoad:
			if 0 > ECast:
				var ESpell = _ESpell.instance()
				get_parent().add_child(ESpell)
				ESpell.Launch(Vector2(position.x + 8, position.y - 12), rotation_degrees + rand_range(ELoad / 2, -ELoad / 2), EDamage, 0b11100000000000000000)
				ESpell.modulate = Color(0.8, 0.8, 1)
				EArrow -= 1
				E = ECD
				ECast = 10
				EShootRelease = 5
				if not EArrow:
					ELoad = 0
					EShoot = false
		EOnClick = false
	
	if Input.is_action_pressed("Spell3"):
		if not ROnClick and R <= 0:
			if RCast:
				RCast -= 1
				RShoot = true
				speedtick /= 3
			else:
				var RSpell = _RSpell.instance()
				get_parent().add_child(RSpell)
				RSpell.Launch(Vector2(position.x + 8, position.y - 12), rotation_degrees + rand_range(RPrecision / 2, -RPrecision / 2), RDamage, 0b11100000000000000000)
				ROnClick = true
				RShoot = false
				RShootRelease = 5
				R = RCD
	else:
		RCast = 2
		RShoot = false
		ROnClick = false

func Cooldown(delta):
	if Q > 0:
		Q -= (delta * 60)
	if W > 0:
		W -= (delta * 60)
	if E > 0:
		E -= (delta * 60)
	if ECast > 0:
		ECast -= (delta * 60)
	if R > 0:
		R -= (delta * 60)
	if RPrecision >= 0:
		RPrecision -= (delta * 60)
	elif RPrecision < 0:
		RPrecision = 0
	if Stunn:
		Stunn -= (delta * 60)
	if Scripted:
		Scripted -= (delta * 60)
	if ModulateReset > 0:
		ModulateReset -= 1
	elif ModulateReset == 0:
		modulate = Color(1, 1, 1)
		ModulateReset = -1

func Modulate(Mod, Reset):
	modulate = Color(Mod)
	ModulateReset = Reset

func Dead():
	Modulate(Color(0.5, 0.5, 0.5), -1)
	Death = true
	
func ScriptAction(delta):
	if ScriptedAction == "Dash":
		Modulate(Color(1.5, 1, 1.5), 1)
		velocity = move_and_collide(Scriptedvelocity.normalized() * delta * 60 * DashSpeed)
		velocity = Vector2()

""" ===0=== """

func _ready():
	randomize()
	set_position(Vector2(rand_range(-400, -100),rand_range(-200, 200)))

func _process(delta):
	speedtick = speed
	Cooldown(delta)
	if Hp <= 0:
		Dead()
	elif Stunn > 0 or Scripted > 0:
		ScriptAction(delta)
	else:
		ScriptedAction = ""
		get_input(delta)
		Movements(delta)
	SelectAnim(delta)
