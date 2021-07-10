extends KinematicBody2D

""""""

onready var NodeAnimation = $Animations
onready var WhiteLight = $Light
onready var RedLight = $RedLight
onready var Time = $Timer

var velocity = Vector2()
var speed = 15
var End = false

""""""

func Movement(delta):
	velocity = (velocity.normalized().rotated(rotation) * speed) * (delta * 60)
	velocity = move_and_collide(velocity)
	if velocity:
		NodeAnimation.frame = 0
		End = true
	velocity = Vector2()

func Launch(LauncherPosition: Vector2, LauncherDirection):
	visible = false
	position = LauncherPosition
	rotation_degrees = LauncherDirection
	velocity = (velocity.normalized().rotated(rotation) * speed)
	

func EndAnimWaiter():
	WhiteLight.energy -= 0.25
	RedLight.energy -= 0.5
	queue_free()

""""""

func _process(delta):
	if End or not Time.get_time_left():
		EndAnimWaiter()
	else:
		visible = true
		velocity.x = 1
		Movement(delta)
