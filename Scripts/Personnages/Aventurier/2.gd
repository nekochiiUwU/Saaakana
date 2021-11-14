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
var negaOrirot = false
var rot
var is_projectile = true
""""""

# Fonction d'Init
func Launch(LauncherDirection, _Damage, CollisionLayer):
	visible = false
	#rotation_degrees = LauncherDirection
	Damage = _Damage
	Hitbox.collision_mask = CollisionLayer
	Hitbox.set_collision_layer_bit(20, false)
	if -90 < get_parent().rotation_degrees and get_parent().rotation_degrees < 90:
		rot = 10
		position += Vector2(5, -11)
		rotation_degrees = - 90
		orirot = - 90
	else:
		self.flip_v = true
		negaOrirot = true
		rot = -10
		position += Vector2(5, 11) 
		rotation_degrees = + 90 
		orirot = + 90 
	visible = true
	
func _process(_delta):
	rotation_degrees += rot * _delta * 60
	if negaOrirot:
		if rotation_degrees <  orirot - 120:
			queue_free()
	else:
		if rotation_degrees >  orirot + 120:
			queue_free()
		
# Joueur touché
func _on_Area_body_entered(body):
	if not body in OverlappedBodies:
		OverlappedBodies.append(body) 
		body.Hp -= Damage
		body.Modulate(Color(1, 0.5, 0.5), 3)
	
