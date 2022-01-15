extends KinematicBody2D

""""""
onready var NodeAnimation = $Animation
onready var Hitbox = $Area
onready var particules = preload("res://Scenes/Personnages/Nya/Particules.tscn")
var particule
var launcher = []
var velocity = Vector2(1, 0)
var speed = 8
var End = 0
var Rebond = 0
var Damage = 100
var collision = false
var is_projectile = true
var scale_
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
		position += Vector2(8, -8).rotated(rotation)
	else:
		position += Vector2(8, -8).rotated(rotation)
	visible = true

func _process(delta):
	if End:
		EndAnimWaiter()
	else:
		collision = move_and_collide(velocity * speed * (delta * 60))
		if collision:
			queue_free()
	
# Joueur touché
func _on_Area_body_entered(body):
	End = body

# Application des dégats
func EndAnimWaiter():
	End.Hp -= Damage
	#End.velocity += Vector2(Damage / 10, 0).rotated(rotation)
	End.Modulate(Color(1, 0.5, 0.5), 3)
	queue_free()
