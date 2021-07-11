extends KinematicBody2D

""""""

onready var NodeAnimation = $Animations
onready var Time = $LifeTime
onready var Hitbox = $Area

var launcher = []
var velocity = Vector2()
var speed = 15
var End = 0
var Damage = 100
""""""

func Movement(delta):
	velocity = (velocity.normalized().rotated(rotation) * speed) * (delta * 60)
	velocity = move_and_collide(velocity)
	if velocity:
		NodeAnimation.frame = 0
		End = 1
	velocity = Vector2()

func Launch(LauncherPosition: Vector2, LauncherDirection, _Damage, CollisionLayer):
	visible = false
	position = LauncherPosition
	rotation_degrees = LauncherDirection
	Damage = _Damage
	velocity = (velocity.normalized().rotated(rotation) * speed)
	collision_mask = CollisionLayer
	Hitbox.collision_mask = CollisionLayer
	Hitbox.set_collision_layer_bit(20, false)
	
func _on_Area2D_body_entered(body):
	print('uwuwowo')
	
func EndAnimWaiter():
	print("EndAnimWaiter")
	if End < 5:
		End += 1
	else:
		for item in Hitbox.get_overlapping_bodies():
			if item.get_parent().name  == "Entities":
				item.Hp -= Damage
		queue_free()

func _process(delta):
	if End or not Time.get_time_left():
		EndAnimWaiter()
	else:
		visible = true
		velocity.x = 1
		Movement(delta)
