extends KinematicBody2D

""""""
onready var NodeAnimation = $Animations
onready var _Spell5 = load("res://Scenes/Personnages/Nya/5.tscn")
var launcher = []
var velocity = Vector2(1, 0)
var speed = 6
var End = 0
var collision = false
var is_projectile = false
var damage
var collisionLayer
var Spell5_
""""""

# Fonction d'Init
func Launch(LauncherPosition: Vector2, LauncherDirection, _Damage, CollisionLayer):
	visible = false
	position = LauncherPosition
	velocity = Vector2(1, 0).rotated(rotation)
	damage = _Damage
	collisionLayer = CollisionLayer
	if -90 < rotation_degrees and rotation_degrees < 90:
		move_and_collide(Vector2(8, -14).rotated(rotation))
	else:
		move_and_collide(Vector2(8, 14).rotated(rotation))

func _process(_delta):
	if get_parent().s.FiveOnClick == false:
		EndAnimWaiter()
	else:
		visible = true

func _physics_process(delta):
	# Mouvement
	collision = velocity * speed * (delta * 60)
	collision = move_and_collide(collision)

# Application des dégats
func EndAnimWaiter():
	Spell5_ = get_parent().s._Spell5.instance()
	get_parent().s.get_parent().add_child(Spell5_)
	Spell5_.Launch(Vector2(get_parent().s.position.x, get_parent().s.position.y), get_parent().s.rotation_degrees, damage, collisionLayer, Vector2(position.x, position.y))
	Spell5_.self_modulate = get_parent().s.SpellColor
	queue_free()
