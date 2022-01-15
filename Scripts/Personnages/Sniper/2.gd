extends KinematicBody2D

""""""
onready var NodeAnimation = $Animations
onready var Hitbox = $Area
onready var particules = preload("res://Scenes/Personnages/Nya/Particules.tscn")
var particule
var launcher = []
var velocity = Vector2(1, 0)
var speed = 0
var End = 0
var Rebond = 0
var Damage = 100
var collision = false
var is_projectile = true
var vie = 4
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
		position += Vector2(8, -5).rotated(rotation)
	else:
		position += Vector2(8, -5).rotated(rotation)
	visible = true
	
func _process(delta):
		if  vie > 0:
			vie -= delta*60
		else:
			Hit()
	
# Joueur touché

# Application des dégats
func Hit():
	var bodies = Hitbox.get_overlapping_bodies()
	for body in bodies:
		body.Hp -= Damage
		body.Modulate(Color(1, 0.5, 0.5), 3)
	queue_free()
