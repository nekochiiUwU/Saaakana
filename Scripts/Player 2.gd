extends KinematicBody2D

onready var _Projectile = preload("res://Scenes/Projectile.tscn")

var Hp = 100
var Auto = 0
var speed = 4
var sensi = 0.02
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
	"""
	if MovementDown and not MovementRight and not MovementLeft:
		rotation_degrees = 180
		rotationFactor = rotation
	if MovementUp and not MovementRight and not MovementLeft:
		rotation_degrees = 0
		rotationFactor = rotation
	if MovementRight and not MovementDown and not MovementUp:
		rotation_degrees = 90
		rotationFactor = rotation
	if MovementLeft and not MovementDown and not MovementUp:
		rotation_degrees = 270
		rotationFactor = rotation
	
	if MovementDown and MovementLeft and not MovementRight and not MovementUp:
		rotation_degrees = 225
		rotationFactor = rotation
	if MovementUp and MovementRight and not MovementLeft and not MovementDown:
		rotation_degrees = 45
		rotationFactor = rotation
	if MovementRight and MovementDown and not MovementLeft and not MovementUp:
		rotation_degrees = 135
		rotationFactor = rotation
	if MovementLeft and MovementUp and not MovementRight and not MovementDown:
		rotation_degrees = 315
		rotationFactor = rotation
	"""
	rotation = rotationFactor + Rotate


""""" ===0=== """

func _input(event):
	if event is InputEventMouseMotion:
		Rotate += deg2rad(event.relative.x * (sensi*10))

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
		Rotate += sensi
	if Input.is_action_pressed("Rotation - 2"):
		Rotate -= sensi
	
	if Input.is_action_pressed("Shoot 2"):
		if Auto > 15 and not OnClick:
			Auto -= 15
			var Projectile = _Projectile.instance()
			get_parent().add_child(Projectile)
			Projectile.Launch(position, Rotate)
		OnClick = true
	else:
		OnClick = false

func Cooldown(delta):
	if Auto < 30:
		Auto += (delta * 60)

""" ===0=== """

func _ready():
	visible = true
	Hp = rand_range(1, 100)

func _process(delta):
	Cooldown(delta)
	get_input()
	Movements(delta)
	SelectAnim()

#	if (0 < position.x and 1280 > position.x and 0 < position.y and 720 > position.y):
