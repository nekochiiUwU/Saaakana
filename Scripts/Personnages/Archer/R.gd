extends KinematicBody2D

""""""
onready var NodeAnimation = $Animations
onready var Hitbox = $Area
var launcher = []
var velocity = Vector2(1, 0)
var speed = 10
var Damage = 300
var Bounce = 0
var collision = false
""""""

# Fonction d'Init
func Launch(LauncherPosition: Vector2, LauncherDirection, _Damage, CollisionLayer):
	NodeAnimation.frame = 0
	visible = true
	position = LauncherPosition
	rotation_degrees = LauncherDirection
	Damage = _Damage
	Hitbox.collision_mask = CollisionLayer
	Hitbox.set_collision_layer_bit(20, false)
	#velocity = Vector2(1, 0).rotated(rotation)

func _process(_delta):
	if NodeAnimation.frame >= 8:
		End()
	else:
		visible = true
"""
#func _physics_process(delta):
	# Mouvement
	#collision = velocity * speed * (delta * 60)
	#collision = move_and_collide(collision)
		
	if collision:
		# Compteur de rebond
		if Bounce > 0:
			Bounce -= 1
		else:
			queue_free()
		# Rebond
		var u = (velocity.dot(collision.normal) / collision.normal.dot(collision.normal)) * collision.normal
		var w = velocity - u
		velocity = w - u
		rotation = atan2(velocity.y, velocity.x)
		
# Joueur touché
func _on_Area_body_entered(body):
	End.append(body)
"""
# Application des dégats
func End():
	var bodies = Hitbox.get_overlapping_bodies()
	for body in bodies:
		body.Hp -= Damage
		body.Modulate(Color(1, 0.5, 0.5), 3)
	queue_free()
