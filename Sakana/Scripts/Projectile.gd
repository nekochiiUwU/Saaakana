extends KinematicBody2D

""""""

onready var NodeAnimation = $Animations
onready var WhiteLight = $Light
onready var RedLight = $RedLight

var velocity = Vector2()
var speed = 15
var Rotate = 0
var End = false
""""""

func Movement(delta):
	rotation = Rotate
	velocity = (velocity.normalized().rotated(Rotate) * speed) * (delta * 60)
	velocity = move_and_collide(velocity)
	if velocity:
		NodeAnimation.animation = "Explosion"
		NodeAnimation.frame = 0
		End = true
	velocity = Vector2()

func Launch(LauncherPosition: Vector2, LauncherDirection):
	visible = false
	position = LauncherPosition
	Rotate = LauncherDirection
	velocity = (velocity.normalized().rotated(Rotate) * speed)

func EndAnimWaiter():
	WhiteLight.energy -= 0.3
	RedLight.energy -= 0.3
	if NodeAnimation.frame == 5:
		queue_free()

""""""

func _process(delta):
	if End:
		EndAnimWaiter()
	else:
		visible = true
		velocity.y -= 1
		Movement(delta)
