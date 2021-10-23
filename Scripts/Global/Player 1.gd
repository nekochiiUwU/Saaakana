extends KinematicBody2D
onready var Camera = get_node("../../../World/Cameras/Camera")
onready var Player2 = get_node("../../Player 2/Player")
onready var P = preload("res://Scripts/Personnages/Archer/Script.gd").new()
onready var Frame = $Frame

var bop
var condition
var movedition
# CC[['nomducc',dureeRestanteEnFrames],]
var CC = []
var animCC = ""
var rotationSensi = (64)/60
var EnemyLayer = 0b11100000000000000000
var delta = 1

"""MALEDICTION"""

"""commun et relatif archer"""
var _QSpell = load("res://Scenes/Personnages/Archer/Q.tscn")
var _WSpell = load("res://Scenes/Personnages/Archer/W.tscn")
var _ESpell = load("res://Scenes/Personnages/Archer/E.tscn")
var _RSpell = load("res://Scenes/Personnages/Archer/R.tscn")
var Qspell
var Wspell
var Espell
var Rspell

var Hp = 1
var MaxHp = 1
var Death = 1

var Q = 1
var QCD = 1
var QCast = 1
var QDamage 
var QShootRelease 
var QShoot
var QOnClick 

var W = 1
var WCD = 1
var WCD1= 1
var WCD2= 1
var WCast 
var WState 
var WDamage 
var WShootRelease 
var WDash
var WShoot 
var WOnClick

var E = 1
var ECD = 1
var ECast 
var ELoad 
var EArrow 
var EMaxLoad
var EDamage 
var EShootRelease
var EShoot
var EOnClick

var R = 1
var RCD = 1
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

"""relatif aventurier"""
""" ===0=== """

func Movements():
	velocity = move_and_collide(velocity.normalized() * delta * speedtick)
	velocity = Vector2()

""" ===0=== """

func get_input():
	movedition = [Input.is_action_pressed("Move Right"), Input.is_action_pressed("Move Left"), Input.is_action_pressed("Move Down"), Input.is_action_pressed("Move Up")]
	P.Mowes(self, movedition)
	
	condition = [Input.is_action_pressed("Rotation +"), Input.is_action_pressed("Rotation -"), Input.is_action_just_pressed("Lock")]
	P.Rwtate(self, condition)

	condition = Input.is_action_pressed("Spell0")
	P.SpellQ(self, condition)
		
	condition = Input.is_action_pressed("Spell1")
	P.SpellW(self, condition)
		
	condition = Input.is_action_pressed("Spell2")
	P.SpellE(self, condition)
	
	condition = Input.is_action_pressed("Spell3")
	P.SpellR(self, condition)

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

""" ===0=== """

func _ready():
	print()
	#if load("res://Scripts/Global/ChampSelect.gd").player1 == Archer
	#P = load("res://Scripts/Personnages/Archer/Script.gd")
	randomize()
	set_position(Vector2(rand_range(-400, -100),rand_range(-200, 180)))
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
