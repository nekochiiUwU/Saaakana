extends Node2D

""""""
onready var _Spell6 = load("res://Scenes/Personnages/Nya/6.tscn")
var launcher = []
var velocity = Vector2(1, 0)
var speed = 7
var End = 0
var collision = false
var is_projectile = false
var damage
var collisionLayer
var Spell6_
""""""

# Fonction d'Init
func Launch(_LauncherDirection, _Damage, CollisionLayer):
	visible = false
	velocity = Vector2(1, 0).rotated(rotation)
	damage = _Damage
	collisionLayer = CollisionLayer
	"""
	if -90 < get_parent().rotation_degrees and get_parent().rotation_degrees < 90:
		position += Vector2(8, -14).rotated(get_parent().rotation)
	else:
		position +=  Vector2(8, -14).rotated(get_parent().rotation)	
	"""

func _process(delta):
	if get_parent().SixOnClick == false:
		EndAnimWaiter()
	else:
		position += velocity * speed * (delta * 60)
		visible = true

# Application des dégats
func EndAnimWaiter():
	Spell6_ = _Spell6.instance()
	get_parent().get_parent().add_child(Spell6_)
	Spell6_.Launch(get_parent().position, get_parent().rotation_degrees, damage, collisionLayer, get_global_position())
	Spell6_.self_modulate = get_parent().SpellColor
	queue_free()
