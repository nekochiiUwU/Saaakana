extends KinematicBody2D

onready var _Auto = preload("res://Scenes/Fleche.tscn")
onready var Frame = $Frame

var Hp = 1000
var MaxHp = 1000
var Auto = 0
var AutoDamage = 100
var speed = 4
var sensi = 2
var Rotate = 0
var rotationFactor = 0
var collision_info = 0
var velocity = Vector2()
var MovementRight = false
var MovementLeft = false
var MovementDown = false
var MovementUp = false
var OnClick = false

""" ===0=== """

func Movements(delta):
	velocity = (velocity.normalized() * speed) * (delta * 60)
	""".rotated(Rotate)"""
	velocity = move_and_collide(velocity)
	velocity = Vector2()

func SelectAnim():
	if MovementDown and not MovementRight and not MovementLeft:
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

""""" ===0=== """

func get_input():
	MovementRight = false
	MovementLeft = false
	MovementDown = false
	MovementUp = false
	
	if Input.is_action_pressed("Move Right 2"):
		velocity.x += 1
		MovementRight = true
	if Input.is_action_pressed("Move Left 2"):
		velocity.x -= 1
		MovementLeft = true
	if Input.is_action_pressed("Move Down 2"):
		velocity.y += 1
		MovementDown = true
	if Input.is_action_pressed("Move Up 2"):
		velocity.y -= 1
		MovementUp = true
	
	if MovementRight and MovementLeft:
		MovementRight = false
		MovementLeft = false
	if MovementDown and MovementUp:
		MovementDown = false
		MovementUp = false
	
	if Input.is_action_pressed("Rotation + 2"):
		rotation_degrees += sensi
		
	if Input.is_action_pressed("Rotation - 2"):
		rotation_degrees -= sensi
	
	if Input.is_action_pressed("Shoot 2"):
		if Auto > 50 and not OnClick:
			Auto -= 50
			var Auto = _Auto.instance()
			get_parent().add_child(Auto)
			Auto.Launch(position, rotation_degrees, AutoDamage, 0b11010000000000000001)
		OnClick = true
	else:
		OnClick = false

func Cooldown(delta):
	if Auto < 100:
		Auto += (delta * 60)

	if Hp < MaxHp / 4:
		Hp += MaxHp * delta

""" ===0=== """

func _ready():
	""""""

func _process(delta):
	Cooldown(delta)
	get_input()
	Movements(delta)
	SelectAnim()
