extends KinematicBody2D

var Spell2_
var Spell4_
var Spell5_
var Spell6_

""" ===0=== """

func Launch(s):
	var frames = load("res://Scenes/Personnages/Aventurier/frames.tscn").instance()
	s.add_child(frames)
	s.Frame = frames
	if s.EnemyLayer != 0b11100000000000000000:
		s.Frame.material = s.Frame.material.duplicate()
		s.Frame.material.set_shader_param('Color', Color(1.0, 0.0, 0.0, 1.0) )
		
	s._Spell2 = load("res://Scenes/Personnages/Aventurier/2.tscn")
	#s._Spell4 = load("res://Scenes/Personnages/Aventurier/4.tscn")
	s._Spell5 = load("res://Scenes/Personnages/Aventurier/5.tscn")
	s._Spell6 = load("res://Scenes/Personnages/Aventurier/6.tscn")

	s.Hp = 1000
	s.MaxHp = 1000
	s.Death = false
	s.speed = 3.75
	s.speedtick = s.speed

	s.Cd2 = 0
	s.Cd2Base = 12
	s.QCast = 7
	s.QDamage = 40
	s.QShootRelease = 0
	s.Anim2 = false
	s.TwoOnClick = false

	s.Cd4 = 0
	s.Cd4Base = 180
	s.FourOnClick = false
	s.WCast = 0
	s.WState = 0
	s.WDamage = 50
	s.WShootRelease = 0
	s.WDash = false
	s.WShoot = false
	s.WOnClick = false

	s.Cd5 = 0
	s.Cd5Base = 300
	s.FiveOnClick = false
	s.ECast = 10
	s.ELoad = 0
	s.EArrow = 0
	s.EMaxLoad = 30
	s.EDamage = 75
	s.EShootRelease = 0
	s.EShoot = false
	s.EOnClick = false

	s.Cd6 = 0
	s.Cd6Base = 240
	s.RCast = 5
	s.RPrecision = 100
	s.RDamage = 100
	s.RShootRelease = 0
	s.RShoot = false
	s.ROnClick = false

	s.ModulateReset = -1

	s.sensi = 3
# warning-ignore:standalone_expression
	s.rotationSensi
	s.Rotate = 0
	s.rotationFactor = 0
	s.collision_info = 0
	s.velocity = Vector2()
	s.Scriptedvelocity = Vector2()
	s.MovementRight = false
	s.MovementLeft = false
	s.MovementDown = false
	s.MovementUp = false
	s.ScriptedAction = ""
	s.DashSpeed = 0
	s.taille = Vector2(10,30)

""" ===0=== """

func SelectAnim(s):
	if s.Death:
		s.Frame.animation = "Ded"
		
	elif s.animCC == "SelfStun":
		s.Frame.animation = "Five"
		
	elif s.Anim2:
		s.Frame.animation = "Two"
		
	elif s.Anim6:
		s.Frame.animation = "Six"
		
	elif s.animCC == "dash":
		s.Frame.animation = "Four"
		
	elif s.MovementDown and not s.MovementRight and not s.MovementLeft:
		s.Frame.animation = "Walk Right"
	elif s.MovementUp and not s.MovementRight and not s.MovementLeft:
		s.Frame.animation = "Walk Right"
	elif s.MovementRight and not s.MovementDown and not s.MovementUp:
		s.Frame.animation = "Walk Right"
	elif s.MovementLeft and not s.MovementDown and not s.MovementUp:
		s.Frame.animation = "Walk Right"
	elif s.MovementDown and s.MovementLeft and not s.MovementRight and not s.MovementUp:
		s.Frame.animation = "Walk Right"
	elif s.MovementUp and s.MovementRight and not s.MovementLeft and not s.MovementDown:
		s.Frame.animation = "Walk Right"
	elif s.MovementRight and s.MovementDown and not s.MovementLeft and not s.MovementUp:
		s.Frame.animation = "Walk Right"
	elif s.MovementLeft and s.MovementUp and not s.MovementRight and not s.MovementDown:
		s.Frame.animation = "Walk Right"
	else:
		s.Frame.animation = "Stand"

	while s.rotation_degrees > 180:
		s.rotation_degrees -= 360
	while s.rotation_degrees < -180:
		s.rotation_degrees += 360

	if -90 < s.rotation_degrees and s.rotation_degrees < 90:
		s.Frame.flip_v = false
	else:
		s.Frame.flip_v = true

""" ===0=== """

func Movements(s):
	s.velocity = move_and_collide(s.velocity.normalized() * s.delta * s.speedtick)
	s.velocity = Vector2()

""""" ===0=== """

func Moves(s, condition):
	s.MovementRight = false
	s.MovementLeft = false
	s.MovementDown = false
	s.MovementUp = false
	if condition[0]:
		s.velocity.x += 1
		s.MovementRight = true
	if condition[1]:
		s.velocity.x -= 1
		s.MovementLeft = true
	if condition[2]:
		s.velocity.y += 1
		s.MovementDown = true
	if condition[3]:
		s.velocity.y -= 1
		s.MovementUp = true
	if s.MovementRight and s.MovementLeft:
		s.MovementRight = false
		s.MovementLeft = false
	if s.MovementDown and s.MovementUp:
		s.MovementDown = false
		s.MovementUp = false
		
func Rotate(s, condition):
	if condition[0]:
		s.rotation_degrees += s.rotationSensi * s.delta 
	if condition[1]:
		s.rotation_degrees -= s.rotationSensi * s.delta
	if condition[2]:
		s.Player2pos = s.Player2.get_position()
		s.rotation = -atan2(s.Player2pos.x - s.position.x, s.Player2pos.y - s.position.y) + PI/2
		s.RPrecision = 300
		if s.WState == -1 or s.WState == 1:
			s.W = s.WCD
			s.WState = 0

func Spell2(s, Condition):
	if s.Cd2 > 0:
		s.speedtick /= 2
	if Condition:
		if not s.TwoOnClick and not s.Cd2 > 0:
			s.Anim2 = true
			Spell2_ = s._Spell2.instance()
			s.add_child(Spell2_)
			Spell2_.Launch(s.rotation_degrees, s.QDamage, s.EnemyLayer)
			Spell2_.self_modulate = s.SpellColor
			s.TwoOnClick = true
			s.Cd2 = s.Cd2Base
	else:
		s.TwoOnClick = false
		if s.Cd2 < 0:
			s.Anim2 = false

func Spell4(s, Condition):
	if Condition:
		if not s.FourOnClick and not s.Cd4 > 0: 
			var Scriptedvelocity = Vector2()
			s.DashSpeed = 7
			if s.movedition[0]:
				Scriptedvelocity.x = 10
			if s.movedition[1]:
				Scriptedvelocity.x -= 10
			if s.movedition[2]:
				Scriptedvelocity.y += 10
			if s.movedition[3]:
				Scriptedvelocity.y -= 10
			s.CC.append(["Dash", 8.0, 7, Scriptedvelocity])
			s.Cd4 = s.Cd4Base
	else:
		s.FourOnClick = false

func Spell5(s, Condition):
	if Condition:
		if not s.FiveOnClick and not s.Cd5 > 0: 
			s.CC.append(["SelfStun",18.0])
			Spell5_ = s._Spell5.instance()
			s.add_child(Spell5_)
			Spell5_.Launch(s.rotation_degrees, s.QDamage, s.EnemyLayer, s.collision_layer)
			s.Cd5 = s.Cd5Base
	else:
		s.FiveOnClick = false
	
func Spell6(s, Condition):
	if s.Cd6 < s.Cd6Base-10:
		s.Anim6 = false
	else:
		s.speedtick /= 2
	if Condition:
		if not s.SixOnClick and not s.Cd6 > 0:
			s.Anim6 = true
			Spell6_ = s._Spell6.instance()
			s.get_parent().add_child(Spell6_)
			Spell6_.Launch(Vector2(s.position.x, s.position.y), s.rotation_degrees, s.RDamage, s.EnemyLayer)
			Spell6_.self_modulate = s.SpellColor
			s.TwoOnClick = true
			s.Cd6 = s.Cd6Base
	else:
		s.SixOnClick = false

func Cooldown(s):
	if s.Cd2 > 0:
		s.Cd2 -= s.delta
	if s.Cd4 > 0:
		s.Cd4 -= s.delta
	if s.Cd5 > 0:
		s.Cd5 -= s.delta
	if s.ECast > 0:
		s.ECast -= s.delta
	if s.Cd6 > 0:
		s.Cd6 -= s.delta
	if s.RPrecision >= 0:
		s.RPrecision -= s.delta
	elif s.RPrecision < 0:
		s.RPrecision = 0
	if s.ModulateReset > 0:
		s.ModulateReset -= s.delta
	elif -1000 != s.ModulateReset and s.ModulateReset < 0:
		s.modulate = Color(1, 1, 1)
		s.ModulateReset = -1

func Modulate(s, Mod, Reset):
	s.modulate = Color(Mod)
	s.ModulateReset = Reset

func Dead(s):
	Modulate(s, Color(0.5, 0.5, 0.5), -1)
	s.Death = true
	
""" ===0===""""""""""""""""""
""""""

func _ready():
	randomize()
	set_position(Vector2(rand_range(-400, -100),rand_range(-200, 200)))

func _process(delta):
	speedtick = speed
	Cooldown(delta)
	if Hp <= 0:
		Dead()
	elif Stunn > 0 or Scripted > 0:
		ScriptAction(delta)
	else:
		ScriptedAction = ""
		
		get_input(delta)
		s.Movements(delta)
	SelectAnim(delta)
"""
