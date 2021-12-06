extends KinematicBody2D
onready var Camera = get_node("../../../World/Cameras/Camera")
onready var Player2 = get_node("../../Player 1/Player")
onready var hitbox = $AreaCheck
var P

var bop
var condition
var movedition
# CC[['nomducc',dureeRestanteEnFrames],]
var CC = []
var animCC = ""
var rotationSensi = (64)/60
var EnemyLayer = 0b11010000000000000000
var is_projectile = false
var SpellColor = Color(0.9, 0.9, 1.1)
var delta = 1

"""MALEDICTION"""

"""commun et |relatif archer|"""
var Frame
var _QSpell
var _WSpell
var _ESpell
var _RSpell
var Qspell
var Wspell
var Espell
var Rspell

var Hp = 1
var MaxHp = 1
var Death = 1

var Cd2 = 1
var Cd2Base = 1
var QCast = 1
var QDamage 
var QShootRelease 
var QShoot
var QOnClick 

var Cd4 = 1
var Cd4Base = 1
var WCD1= 1
var WCD2= 1
var WCast 
var WState 
var WDamage 
var WShootRelease 
var WDash
var WShoot 
var WOnClick

var Cd5 = 1
var Cd5Base = 1
var ECast 
var ELoad 
var EArrow 
var EMaxLoad
var EDamage 
var EShootRelease
var EShoot
var EOnClick

var Cd6 = 1
var Cd6Base = 1
var RCast 
var RPrecision 
var RDamage 
var RShootRelease
var RShoot
var ROnClick

var speed 
var speedtick

var ModulateReset 

var Player2pos
var sensi  
var Rotate 
var rotationFactor
var collision_info
var velocity
var Scriptedvelocity 
var MovementRight 
var MovementLeft 
var MovementDown
var MovementUp
var ScriptedAction
var DashSpeed
var oldColl

"""relatif aventurier"""
var _Spell2
var _Spell4
var _Spell5
var _Spell6

var TwoOnClick
var Anim2

var FourOnClick
var Anim4

var FiveOnClick
var damage5
var Anim5

var SixOnClick
var Anim6

""" ===0=== """

func Movements():
	velocity = move_and_collide(velocity.normalized() * delta * speedtick)
	velocity = Vector2()

""" ===0=== """

func get_input():
	movedition = [Input.is_action_pressed("Move Right 2"), Input.is_action_pressed("Move Left 2"), Input.is_action_pressed("Move Down 2"), Input.is_action_pressed("Move Up 2")]
	P.Moves(self, movedition)
	
	condition = [Input.is_action_pressed("Rotation + 2"), Input.is_action_pressed("Rotation - 2"), Input.is_action_just_pressed("Lock 2")]
	P.Rotate(self, condition)

	condition = Input.is_action_pressed("Spell0 2")
	P.Spell2(self, condition)
		
	condition = Input.is_action_pressed("Spell1 2")
	P.Spell4(self, condition)
		
	condition = Input.is_action_pressed("Spell2 2")
	P.Spell5(self, condition)
	
	condition = Input.is_action_pressed("Spell3 2")
	P.Spell6(self, condition)

func Modulate(Mod, Reset):
	modulate = Color(Mod)
	ModulateReset = Reset

func Dead():
	Modulate(Color(0.5, 0.5, 0.5), -1)
	Death = true
	
func CrowdControl(AWAJANIMAL):
	if AWAJANIMAL[0] == "Dash":
		animCC = "dash"
		Modulate(Color(1.5, 1, 1.5), 1)
		velocity = move_and_collide(Scriptedvelocity.normalized() * delta * DashSpeed)
		velocity = Vector2()
	elif AWAJANIMAL[0] == "SelfStun":
		animCC = "SelfStun"

""" ===0=== """

func _ready():
	print()
	if get_viewport().get_child(0).Champs[1] == "Archer":
		P = load("res://Scripts/Personnages/Archer/Script.gd").new()
	elif get_viewport().get_child(0).Champs[1] == "Aventurier":
		P = load("res://Scripts/Personnages/Aventurier/Script.gd").new()
	elif get_viewport().get_child(0).Champs[1] == "Nya":
		P = load("res://Scripts/Personnages/Nya/Script.gd").new()
	else:
		P = load("res://Scripts/Personnages/Archer/Script.gd").new()
	randomize()
	set_position(Vector2(rand_range(400, -100),rand_range(-200, 180)))
	P.Launch(self)

func _process(delta_):
	delta = delta_ * 60 
	speedtick = speed
	P.Cooldown(self)
	
	if Hp <= 0:
		Dead()
	else:
		bop = true
		for i in CC:
			if i[1] > 0:
				bop = false
				CrowdControl(i)
				i[1] -= delta
				#print(i[1])
		if bop:
			CC = []
			animCC = ""
			get_input()
			Movements()
	P.SelectAnim(self)

