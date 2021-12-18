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
var EndList = []
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
	frame = 0
	visible = true
		
func _process(_delta):
	if frame < 10:
		scale += Vector2(0.25,0.25)
	else:
		queue_free()
		
	if End:
		EndAnimWaiter()
		End = 0

func _on_Hitbox_body_entered(body):
	if not body in EndList:
		EndList.append(body)
		End = body
	
# Application des dégats
func EndAnimWaiter():
	End.Hp -= Damage
	End.speedtick /= 2
	End.CC.append(["Dash", 13.0, 9, (End.position-position).normalized()])
	End.Modulate(Color(1, 0.5, 0.5), 3)
