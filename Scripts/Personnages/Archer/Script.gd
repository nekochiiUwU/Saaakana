extends KinematicBody2D

var QSpell
var WSpell
var ESpell
var RSpell

""" ===0=== """

func Launch(s):
	var frames = load("res://Scenes/Personnages/Archer/frames.tscn").instance()
	s.add_child(frames)
	s.Frame = frames
	if s.EnemyLayer != 0b11100000000000000000:
		s.Frame.material = s.Frame.material.duplicate()
		s.Frame.material.set_shader_param('Color', Color(1.0, 0.0, 0.0, 1.0) )
	
	s._QSpell = load("res://Scenes/Personnages/Archer/Q.tscn")
	s._WSpell = load("res://Scenes/Personnages/Archer/W.tscn")
	s._ESpell = load("res://Scenes/Personnages/Archer/E.tscn")
	s._RSpell = load("res://Scenes/Personnages/Archer/R.tscn")

	s.Hp = 1000
	s.MaxHp = 1000
	s.Death = false

	s.Cd2 = 0
	s.Cd2Base = 20
	s.QCast = 7
	s.QDamage = 50
	s.QShootRelease = 0
	s.QShoot = false
	s.QOnClick = false

	s.Cd4 = 0
	s.Cd4Base = 600
	s.WCD1 = 0
	s.WCD2 = 0
	s.WCast = 0
	s.WState = 0
	s.WDamage = 50
	s.WShootRelease = 0
	s.WDash = false
	s.WShoot = false
	s.WOnClick = false

	s.Cd5 = 0
	s.Cd5Base = 480
	s.ECast = 10
	s.ELoad = 0
	s.EArrow = 0
	s.EMaxLoad = 30
	s.EDamage = 75
	s.EShootRelease = 0
	s.EShoot = false
	s.EOnClick = false

	s.Cd6 = 0
	s.Cd6Base = 420
	s.RCast = 5
	s.RPrecision = 100
	s.RDamage = 125
	s.RShootRelease = 0
	s.RShoot = false
	s.ROnClick = false

	s.speed = 3
	s.speedtick = s.speed

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

""" ===0=== """

func SelectAnim(s):
	if s.Death:
		s.Frame.animation = "Ded"
		
	elif s.QShoot or s.WShoot:
		s.Frame.animation = "Tir"
		
	elif 0 < s.EShootRelease:
		s.Frame.animation = "Release"
		s.EShootRelease -= s.delta
		
	elif s.EShoot:
		s.Frame.animation = "Tir"
	
	elif 0 < s.QShootRelease or 0 < s.WShootRelease or 0 < s.RShootRelease:
		s.Frame.animation = "Release"
		s.QShootRelease -= s.delta
		s.WShootRelease -= s.delta
		s.RShootRelease -= s.delta
		
	elif s.animCC == "dash":
		s.Frame.animation = "Dash"
		
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
			s.Cd4 = s.Cd4Base
			s.WState = 0

func Spell2(s, Condition):
	if Condition:
		if not s.QOnClick and not s.Cd2 > 0:
			if s.QCast > 0:
				s.QCast -= s.delta
				s.QShoot = true
				s.speedtick /= 3
			else:
				QSpell = s._QSpell.instance()
				s.get_parent().add_child(QSpell)
				QSpell.Launch(Vector2(s.position.x, s.position.y), s.rotation_degrees, s.QDamage, s.EnemyLayer)
				QSpell.NodeAnimation.self_modulate = s.SpellColor
				s.QOnClick = true
				s.QShoot = false
				s.QShootRelease = 5
				s.Cd2 = s.Cd2Base
	else:
		s.QCast = 7
		s.QShoot = false
		s.QOnClick = false

func Spell4(s, Condition):
	if Condition:
		if not s.WOnClick and not s.Cd4 > 0:
			if s.WState <= 0:
				if s.WCast > 0:
					s.WCast -= s.delta
					s.WShoot = true
					s.speedtick /= 3
				else:
					WSpell = s._WSpell.instance()
					s.get_parent().add_child(WSpell)
					WSpell.Launch(Vector2(s.position.x, s.position.y), s.rotation_degrees, s.QDamage, s.EnemyLayer)
					WSpell.NodeAnimation.self_modulate = s.SpellColor
					s.WOnClick = true
					s.WShoot = false
					s.WShootRelease = 5
					s.Cd4 = s.Cd4Base
					s.WState = -2
			else:
				s.Scriptedvelocity = Vector2()
				s.CC.append(["Dash",10.0])
				s.DashSpeed = 10
				if s.movedition[0]:
					s.Scriptedvelocity.x = 10
				if s.movedition[1]:
					s.Scriptedvelocity.x -= 10
				if s.movedition[2]:
					s.Scriptedvelocity.y += 10
				if s.movedition[3]:
					s.Scriptedvelocity.y -= 10
				s.WState = -1
				s.Cd4 = s.WCD2
	else:
		s.WCast = 2
		s.WShoot = false
		s.WOnClick = false

func Spell5(s, Condition):
	if Condition:
		if not s.EOnClick and not s.Cd5 > 0:
			s.ELoad = 1
			s.EArrow = 1
			s.EOnClick = true
			s.EShoot = true
		else:
			if not s.Cd5 > 0 and s.EArrow:
				s.Camera.NewNotification("Bar", "Cd5 " + str(s.EArrow) + "- Dispertion", s.EMaxLoad - s.ELoad, s.EMaxLoad, "Player 1", 1)
				s.speedtick /= 3
				if s.ELoad and not s.EArrow > 3:
					if s.ELoad >= s.EMaxLoad and not s.EArrow > 2:
						s.EArrow += 1
						s.ELoad = 1
					else:
						if not s.EArrow > 2 or not s.ELoad >= s.EMaxLoad:
							s.ELoad += s.delta
						else:
							s.ELoad = s.EMaxLoad
							s.EArrow = 3
				
	else:
		if s.ELoad:
			if 0 > s.ECast:
				ESpell = s._ESpell.instance()
				s.get_parent().add_child(ESpell)
				ESpell.Launch(Vector2(s.position.x, s.position.y), s.rotation_degrees + rand_range(s.ELoad / 2, -s.ELoad / 2), s.EDamage, s.EnemyLayer)
				ESpell.NodeAnimation.self_modulate = s.SpellColor
				s.EArrow -= 1
				s.Cd5 = s.Cd5Base
				s.ECast = 10
				s.EShootRelease = 5
				if not s.EArrow:
					s.ELoad = 0
					s.EShoot = false
		s.EOnClick = false
	
func Spell6(s, Condition):
	if Condition:
		if not s.ROnClick and s.Cd6 <= 0:
			if s.RCast > 0:
				s.RCast -= s.delta
				s.RShoot = true
				s.speedtick /= 3
			else:
				RSpell = s._RSpell.instance()
				s.get_parent().add_child(RSpell)
				RSpell.Launch(Vector2(s.position.x, s.position.y), s.rotation_degrees + rand_range(s.RPrecision / 2, -s.RPrecision / 2), s.RDamage, s.EnemyLayer)
				s.ROnClick = true
				s.RShoot = false
				s.RShootRelease = 5
				s.Cd6 = s.Cd6Base
	else:
		s.RCast = 2
		s.RShoot = false
		s.ROnClick = false

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
