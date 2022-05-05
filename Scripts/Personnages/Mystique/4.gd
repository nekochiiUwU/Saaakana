extends KinematicBody2D

""""""
onready var NodeAnimation = $Animation
onready var Hitbox = get_node("Area")
onready var explosion = preload("res://Scenes/Personnages/Mystique/explosion.tscn")
var launcher = []
var velocity = Vector2(1, 0)
var speed = 2
var End = 0
var Rebond = 0
var Damage = 100
var collision = false
var is_projectile = true
var scale_
var player
var has_released = false
var is_decaying = false
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
		if player.FourOnClick == true and is_decaying == false:
			is_decaying = true
			player.last6[0] = player.last6[1]
			player.last6[1] = position
	elif player.FourOnClick == false:
		has_released = true
	if is_decaying:
		speed -= 6*delta
	else:
		speed += (speed/2+1)*delta
	if End:
		EndAnimWaiter()
	elif speed <= 1:
		var _explosion = explosion.instance()
		get_parent().add_child(_explosion)
		_explosion.Launch(position, 140, Hitbox.collision_mask)
		_explosion.self_modulate = self_modulate
		player.state4 = "not launched"
		queue_free()
	else:
		collision = move_and_collide(velocity * speed * (delta * 60))
		if collision:
			player.state4 = "not launched"
			queue_free()
	
# Joueur touché
func _on_Area_body_entered(body):
	End = body

# Application des dégats
func EndAnimWaiter():
	End.Hp -= Damage
	#End.velocity += Vector2(Damage / 10, 0).rotated(rotation)
	End.Modulate(Color(1, 0.5, 0.5), 3)
	player.state4 = "not launched"
	queue_free()
