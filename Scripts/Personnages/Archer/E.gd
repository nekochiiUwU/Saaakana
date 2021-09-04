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
var collision = false
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
	End.TakeDamage()
	queue_free()
