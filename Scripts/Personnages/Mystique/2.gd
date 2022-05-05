extends KinematicBody2D

""""""
onready var NodeAnimation = $Animation
onready var Hitbox = get_node("Area")
onready var pellet = preload("res://Scenes/Personnages/Mystique/Pellet.tscn")
var launcher = []
var velocity = Vector2(1, 0)
var speed = 6
var End = 0
var Rebond = 0
var Damage = 100
var collision = false
var is_projectile = true
var scale_
var player
var has_released = false
""""""

# Fonction d'Init
func Launch(LauncherPosition: Vector2, LauncherDirection, _Damage, CollisionLayer, _player):
	visible = false
	position = LauncherPosition
	rotation_degrees = LauncherDirection
	Damage = _Damage
	player = _player
	
	Hitbox.collision_mask = CollisionLayer
	Hitbox.set_collision_layer_bit(20, false)
	
	velocity = Vector2(1, 0).rotated(rotation)
	if -90 < rotation_degrees and rotation_degrees < 90:
		position += Vector2(8, -8).rotated(rotation)
	else:
		position += Vector2(8, -8).rotated(rotation)
	visible = true

func _process(delta):
	if has_released:
		if player.TwoOnClick == true:
			player.last6[0] = player.last6[1]
			player.last6[1] = position
			for i in range(1, 12):
				var _pellet = pellet.instance()
				get_parent().add_child(_pellet)
				_pellet.Launch(position, rotation_degrees+(i-4)*2, 10, Hitbox.collision_mask)
				_pellet.self_modulate = self_modulate
				player.state2 = "not launched"
				queue_free()
	elif player.TwoOnClick == false:
		has_released = true
	if End:
		player.state2 = "not launched"
		EndAnimWaiter()
	else:
		collision = move_and_collide(velocity * speed * (delta * 60))
		if collision:
			player.state2 = "not launched"
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
