extends KinematicBody2D

""""""

onready var NodeAnimation = $Animations
onready var Hitbox = $Area

var launcher = []
var velocity = Vector2(1, 0)
var speed = 15
var End = 0
var Damage = 100

""""""


func Launch(LauncherPosition: Vector2, LauncherDirection, _Damage, CollisionLayer):
	visible = false
	position = LauncherPosition
	rotation_degrees = LauncherDirection
	Damage = _Damage
	collision_mask = CollisionLayer
	Hitbox.collision_mask = CollisionLayer
	Hitbox.set_collision_layer_bit(20, false)
	velocity = Vector2(speed, 0)

func _physics_process(delta):
	velocity = velocity.normalized().rotated(rotation) * (delta * 60)

	var collision = move_and_collide(velocity)
	if collision:
		rotation = velocity.angle()
		if collision.collider.has_method("hit"):
			collision.collider.hit()

func _on_Area2D_body_entered(body):
	print('uwuwowo')
	
func EndAnimWaiter():
	if End.get_parent().name  == "Entities":
		End.Hp -= Damage
	queue_free()

func _process(delta):
	if End:
		EndAnimWaiter()
	else:
		visible = true


func _on_Area_area_entered(area):
	End = Hitbox.get_overlapping_bodies()[0]
