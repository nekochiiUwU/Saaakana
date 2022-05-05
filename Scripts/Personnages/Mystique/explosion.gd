extends Sprite

""""""
onready var Hitbox = $Area
var launcher = []
var velocity = Vector2(1, 0)
var speed = 6
var End = 0
var Damage = 100
var is_projectile = false
var EndList = []
""""""

# Fonction d'Init
func Launch(LauncherPosition: Vector2, _Damage, collision):
	visible = false
	position = LauncherPosition
	rotation_degrees = 0
	Damage = _Damage
	Hitbox.collision_mask = collision
	Hitbox.set_collision_layer_bit(20, false)
	velocity = Vector2(1, 0).rotated(rotation)
	visible = true
		
func _process(_delta):
	if End:
		EndAnimWaiter()
	if scale > Vector2(17,17):
		scale -= Vector2(7,7)*_delta
		self_modulate.a -= 1.2 * _delta
	elif scale < Vector2(5,5):
		queue_free()
	else:
		if not self_modulate.a < 0:
			self_modulate.a -= 2 * _delta
		else:
			self_modulate.a = 0
		scale -= Vector2(20,20)*_delta


# Application des dégats
func EndAnimWaiter():
	End.Hp -= Damage
	End.speedtick /= 2
	End.Modulate(Color(1, 0.5, 0.5), 3)
	End = 0


func _on_Area_body_entered(body):
	if not body in EndList:
		EndList.append(body)
		End = body
