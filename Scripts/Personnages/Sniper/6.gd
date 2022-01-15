extends Node2D

""""""
onready var proc = preload("res://Scenes/Personnages/Sniper/AoE.tscn")
var launcher = []
var velocity = Vector2(1, 0)
var speed = 7
var End = 0
var collision = false
var is_projectile = false
var damage
var collisionLayer
var ExpectedPos
var rebonds = 3.0
var proc_
var iniDist
var iniDistx
var iniDisty
var scale_
""""""

# Fonction d'Init
func Launch(LauncherPosition: Vector2, LauncherDirection, _Damage, ExpectedPos_):
	visible = false
	position = LauncherPosition
	rotation_degrees = LauncherDirection
	velocity = Vector2(1, 0).rotated(rotation)
	damage = _Damage
	ExpectedPos = ExpectedPos_
	iniDist = get_global_position().distance_to(ExpectedPos)
	iniDisty = (ExpectedPos[1]) - get_global_position().y
	iniDistx = (ExpectedPos[0]) - get_global_position().x
	"""
	if -90 < rotation_degrees and rotation_degrees < 90:
		position += Vector2(8, -14).rotated(rotation)
	else:
		self.flip_v = true
		position += Vector2(8, 14).rotated(rotation)
	"""
	visible = true

func _process(delta):
	if get_global_position().distance_to(ExpectedPos) < (speed * (delta * 60))*2:
		if rebonds < 28:
			ExpectedPos += Vector2(iniDistx/rebonds,iniDisty/rebonds)
			rebonds *= 3
		else:
			EndAnimWaiter()
	else:
		position += (velocity * speed * (delta * 60))
		scale_ = 3*(1-(pow(1-(get_global_position().distance_to(ExpectedPos)/iniDist),4)))
		scale = Vector2(scale_, scale_)

# Application des dégats
func EndAnimWaiter():
	proc_ = proc.instance()
	get_parent().get_parent().add_child(proc_)
	proc_.Launch(ExpectedPos, damage)
	queue_free()
