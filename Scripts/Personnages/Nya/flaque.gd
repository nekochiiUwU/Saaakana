extends AnimatedSprite

""""""
onready var Water = $Water
onready var Hitbox = $Area
var launcher = []
var velocity = Vector2(1, 0)
var speed = 6
var End = 0
var Damage = 100
var is_projectile = false
""""""

# Fonction d'Init
func Launch(LauncherPosition: Vector2, _Damage, CollisionLayer):
	visible = false
	position = LauncherPosition
	rotation_degrees = 0
	Damage = _Damage
	Hitbox.collision_mask = CollisionLayer
	Hitbox.set_collision_layer_bit(20, false)
	velocity = Vector2(1, 0).rotated(rotation)
	visible = true

func _process(_delta):
	if scale[1] < 6:
		scale += Vector2(0.25,0.25)
	else:
		Hitbox.monitoring = false
	if End:
		EndAnimWaiter()
		End = 0
	else:
		visible = true

func _on_Hitbox_body_entered(body):
	End = body
	
# Application des dégats
func EndAnimWaiter():
	End.Hp -= Damage
	End.speedtick /= 2
	#End.velocity += Vector2(Damage / 10, 0).rotated(rotation)
	End.Modulate(Color(1, 0.5, 0.5), 3)
