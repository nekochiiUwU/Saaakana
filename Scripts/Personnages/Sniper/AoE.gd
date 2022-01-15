extends AnimatedSprite

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
func Launch(LauncherPosition: Vector2, _Damage):
	print("uwu")
	visible = false
	position = LauncherPosition
	rotation_degrees = 0
	Damage = _Damage
	Hitbox.collision_mask = 0b11110000000000000000
	Hitbox.set_collision_layer_bit(20, false)
	velocity = Vector2(1, 0).rotated(rotation)
	frame = 0
	visible = true
		
func _process(_delta):
	if End and frame > 5:
		EndAnimWaiter()
		End = 0
	if frame < 9:
		scale += Vector2(0.25,0.25)*_delta*60
	else:
		queue_free()

func _on_Hitbox_body_entered(body):
	if not body in EndList:
		EndList.append(body)
		End = body
	
# Application des dégats
func EndAnimWaiter():
	End.Hp -= Damage
	End.speedtick /= 2
	End.Modulate(Color(1, 0.5, 0.5), 3)
