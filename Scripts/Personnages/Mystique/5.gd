extends KinematicBody2D

""""""
onready var NodeAnimation = $Animation
onready var Hitbox = get_node("Area")
onready var pellet = preload("res://Scenes/Personnages/Mystique/Pellet.tscn")
var launcher = []
var velocity = Vector2(1, 0)
var speed = 3
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
	
	velocity = Vector2(1, 0)
	if -90 < rotation_degrees and rotation_degrees < 90:
		position += Vector2(8, -8).rotated(rotation)
	else:
		position += Vector2(8, -8).rotated(rotation)
	visible = true

func _process(delta):
	if player.FiveOnClick == true:
		if has_released:
			player.last6[0] = player.last6[1]
			has_released = false
		player.last6[1] = position
		if player.MovementRight:
			rotation_degrees += 270*delta
		elif player.MovementLeft:
			rotation_degrees -= 270*delta
	else:
		has_released = true
	if End:
		player.state5 = "not launched"
		EndAnimWaiter()
	else:
		collision = move_and_collide(velocity.rotated(rotation) * speed * (delta * 60))
		if collision:
			player.state5 = "not launched"
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
