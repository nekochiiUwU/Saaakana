extends KinematicBody

onready var Camera = $Camera
var Hp = 100
var Auto = 0
var speed = 0.1
var sensi = 0.02
var Rotate = Vector3()
var rotationFactor = Vector3()
var collision_info = 0
var velocity = Vector3()
var velocityY = Vector3()
var MovementRight = false
var MovementLeft = false
var MovementDown = false
var MovementUp = false
var OnClick = false
var pressed = false
var r = Vector3()

""" ===0=== """

func Movements(delta):
	velocityY = velocity
	velocityY.x = 0 
	velocityY.z = 0
	velocity.y = 0 
	velocityY = (velocityY.normalized() * speed) * (delta * 60)
	velocityY = move_and_collide(velocityY)
	velocity = (velocity.normalized().rotated(Vector3(0, 1, 0), rotationFactor.y) * speed) * (delta * 60)
	velocity = move_and_collide(velocity)
	velocity = Vector3()

func SelectAnim():
	"""
	if MovementDown and not MovementRight not MovementLeft:
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
	
	if -PI < rotationFactor.x + Rotate.x:
		r = Rotate + rotationFactor
		if not rotationFactor.x + Rotate.x < PI:
			r = Vector3(PI, Rotate.y + rotationFactor.y, 0)
	else:
		r = Vector3(-PI, Rotate.y + rotationFactor.y, 0)
	Camera.rotation.x = ( r.x      + Camera.rotation.y * 10) / 11
	Camera.rotation.y = ( -Rotate.y + Camera.rotation.y * 10) / 11
	Camera.rotation.z = ( -Rotate.z + Camera.rotation.z * 10) / 11
	rotation = Vector3(0, r.y, r.z)
	rotationFactor = r
	Rotate = Vector3()


""""" ===0=== """

func _input(event):
	if event is InputEventMouseMotion:
		Rotate = Vector3(-deg2rad(event.relative.y * (sensi*10)), -deg2rad(event.relative.x * (sensi*10)), 0)

func get_input():
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
		velocity.z += 1
		MovementDown = true
	if Input.is_action_pressed("Move Up"):
		velocity.z -= 1
		MovementUp = true
	if MovementRight and MovementLeft:
		MovementRight = false
		MovementLeft = false
	if MovementDown and MovementUp:
		MovementDown = false
		MovementUp = false
	velocity.y = -10
	if Input.is_action_pressed("Rotation +"):
		velocity.y += 10.1
	if Input.is_action_pressed("Rotation -"):
		if not pressed:
			pressed = true
	else:
		pressed = false

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
