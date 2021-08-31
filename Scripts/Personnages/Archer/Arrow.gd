extends KinematicBody2D

""""""

onready var NodeAnimation = $Animations
onready var Hitbox = $Area

var launcher = []
var velocity = Vector2(1, 0)
var speed = 10
var End = 0
var Damage = 100
var Bounce = 1
""""""


func Launch(LauncherPosition: Vector2, LauncherDirection, _Damage, CollisionLayer):
	visible = false
	position = LauncherPosition
	rotation_degrees = LauncherDirection
	Damage = _Damage
	Hitbox.collision_mask = CollisionLayer
	Hitbox.set_collision_layer_bit(20, false)
	velocity = Vector2(speed, 0)

func _process(delta):
	if End:
		EndAnimWaiter()
	else:
		visible = true

func _physics_process(delta):
	var collision = velocity.rotated(rotation) * (delta * 60)
	collision = move_and_collide(collision)
	if collision:
		if Bounce > 0:
			Bounce -= 1
		else:
			queue_free()
		var r = rotation_degrees
		velocity = collision.normal.rotated(rotation_degrees)

		# rotation_degrees = (collision.normal.angle() / (2*PI)) * 360 - ((collision.normal.angle() / (2*PI)) * 360 + rotation_degrees)
		# rotation = collision.normal.angle() - rotation
		# rotation = collision.remainder.rotated(rotation))
		print(velocity)
		print("\n", (collision.normal.angle()/(2*PI))*360, "° \n", r, "° \n", rotation_degrees, "°\n")

func _on_Area_body_entered(body):
	#End = Hitbox.get_overlapping_bodies()[0]
	pass

func EndAnimWaiter():
	if End.get_parent().name  == "Entities":
		End.Hp -= Damage
	queue_free()
