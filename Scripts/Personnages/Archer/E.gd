extends KinematicBody2D

""""""
onready var NodeAnimation = $Animations
onready var Hitbox = $Area
var launcher = []
var velocity = Vector2(1, 0)
var speed = 8
var End = 0
var Damage = 100
var Bounce = 1
var collision = false
var is_projectile = true
""""""

# Fonction d'Init
func Launch(LauncherPosition: Vector2, LauncherDirection, _Damage, CollisionLayer):
	visible = false
	position = LauncherPosition
	rotation_degrees = LauncherDirection
	Damage = _Damage
	Hitbox.collision_mask = CollisionLayer
	Hitbox.set_collision_layer_bit(20, false)
	velocity = Vector2(1, 0).rotated(rotation)
	if -90 < rotation_degrees and rotation_degrees < 90:
		move_and_collide(Vector2(8, -14).rotated(rotation))
	else:
		move_and_collide(Vector2(8, 14).rotated(rotation))

func _process(_delta):
	if End:
		EndAnimWaiter()
	else:
		visible = true

func _physics_process(delta):
	collision = velocity * speed * (delta * 60)
	collision = move_and_collide(collision)
	if collision:
		queue_free()

func _on_Area_body_entered(body):
	End = body

func EndAnimWaiter():
	End.Hp -= Damage
	#End.velocity += Vector2(Damage / 10, 0).rotated(rotation)
	End.Modulate(Color(1, 0.5, 0.5), 3)
	queue_free()
