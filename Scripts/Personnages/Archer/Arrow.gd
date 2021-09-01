extends KinematicBody2D

""""""
onready var NodeAnimation = $Animations
onready var Hitbox = $Area
var launcher = []
var velocity = Vector2(1, 0)
var speed = 10
var End = 0
var Damage = 100
var Bounce = 1
var collision = false
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

func _process(delta):
	if End:
		EndAnimWaiter()
	else:
		visible = true

func _physics_process(delta):
	# Mouvement
	collision = velocity * speed * (delta * 60)
	collision = move_and_collide(collision)

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
	End = Hitbox.get_overlapping_bodies()

# Application des dégats
func EndAnimWaiter():
	for item in End:
		if item.get_parent().name  == "Entities":
			item.Hp -= Damage
	queue_free()
