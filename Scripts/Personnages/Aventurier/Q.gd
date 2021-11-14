extends Node2D

""""""
onready var NodeAnimation = $Animations
onready var Hitbox = $Area
var launcher = []
var velocity = Vector2(1, 0)
var speed = 8
var Damage = 100
var collision = false
var OverlappedBodies = []
var orirot 
var rot
""""""

# Fonction d'Init
func Launch(LauncherDirection, _Damage, CollisionLayer):
	visible = false
	rotation_degrees = LauncherDirection
	Damage = _Damage
	Hitbox.collision_mask = CollisionLayer
	Hitbox.set_collision_layer_bit(20, false)
	velocity = Vector2(1, 0).rotated(rotation)
	if -90 < rotation_degrees and rotation_degrees < 90:
		rot = 10
		position += Vector2(7, -11)#.rotated(rotation))
		rotation_degrees = LauncherDirection-90
		orirot = LauncherDirection-90
	else:
		rot = -10
		position += Vector2(7, 11)#.rotated(rotation)
		rotation_degrees = LauncherDirection+90
		orirot = LauncherDirection+90
	visible = true

func _process(_delta):
	rotation_degrees += rot
	if rotation_degrees >  orirot + 120:
		queue_free()
		
# Joueur touché
func _on_Area_body_entered(body):
	if not body in OverlappedBodies:
		OverlappedBodies.append(body) 
		body.Hp -= Damage
	
