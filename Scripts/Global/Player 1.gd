extends KinematicBody2D

onready var _Auto = preload("res://Scenes/Personnages/Archer/Arrow.tscn")
onready var Frame = $Frame

var Hp = 1000
var MaxHp = 1000
var Auto = 0
var AutoDamage = 50
var AutoCast = 5
var speed = 3
var speedtick = speed
var sensi = 2
var rotationSensi = 128
var Rotate = 0
var rotationFactor = 0
var collision_info = 0
var ShootAutoRelease = 0
var velocity = Vector2()
var MovementRight = false
var MovementLeft = false
var MovementDown = false
var MovementUp = false
var ShootAuto = false
var OnClick = false

""" ===0=== """

func SelectAnim():
	if ShootAuto:
		Frame.animation = "Tir"
	elif ShootAutoRelease:
		Frame.animation = "Release"
		ShootAutoRelease -=1
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
	""".rotated(Rotate)"""
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
		if not OnClick:
			if AutoCast:
				AutoCast -= 1
				ShootAuto = true
				speedtick /= 3
			else:
				var Auto = _Auto.instance()
				get_parent().add_child(Auto)
				Auto.Launch(Vector2(position.x + 8, position.y - 8), rotation_degrees, AutoDamage, 0b11100000000000000001)
				OnClick = true
				ShootAuto = false
				AutoCast = 7
				ShootAutoRelease = 5
	else:
		ShootAuto = false
		OnClick = false

func Cooldown(delta):
	if Auto < 100:
		Auto += (delta * 60)
		
	if Hp < MaxHp / 4:
		Hp += (MaxHp / 100) * delta

""" ===0=== """

func _ready():
	""""""

func _process(delta):
	speedtick = speed
	Cooldown(delta)
	get_input(delta)
	Movements(delta)
	SelectAnim()

#	if (0 < position.x and 1280 > position.x and 0 < position.y and 720 > position.y):
