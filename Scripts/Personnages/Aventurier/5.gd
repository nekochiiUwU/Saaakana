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
var counter = 0
var is_projectile = false
""""""

# Fonction d'Init
func Launch(LauncherDirection, _Damage, CollisionLayer, selfcollision):
	visible = false
	rotation_degrees = LauncherDirection
	Damage = _Damage
	Hitbox.collision_layer = selfcollision
	Hitbox.collision_mask = CollisionLayer
	#self.set_collision_layer_bit(20, false)
	if -90 < rotation_degrees and rotation_degrees < 90:
		position += Vector2(20, -11)#.rotated(rotation)
	else:
		position += Vector2(20, -11)#.rotated(rotation)
	visible = true

func _process(_delta):
	counter += 1 * 60 * _delta
	if counter >  18:
		queue_free()
		
func _on_Node2D_area_entered(area):
	if not area in OverlappedBodies and not area.get_parent().is_projectile:
		OverlappedBodies.append(area) 
		area.get_parent().Launch(self.get_parent().position, rotation_degrees, area.get_parent().Damage, Hitbox.collision_mask)
