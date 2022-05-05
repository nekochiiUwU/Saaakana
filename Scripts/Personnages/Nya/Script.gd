extends KinematicBody2D

var Spell2_
var Spell4_
var Spell5_
var Spell6_

""" ===0=== """

func Launch(s):
	var frames = load("res://Scenes/Personnages/Nya/frames.tscn").instance()
	s.add_child(frames)
	s.Frame = frames
	if s.EnemyLayer != 0b11100000000000000000:
		s.Frame.material = s.Frame.material.duplicate()
		s.Frame.material.set_shader_param('Color', Color(1.0, 0.0, 0.0, 1.0) )
		
	s._Spell2 = load("res://Scenes/Personnages/Nya/2.tscn")
	s._Spell4 = load("res://Scenes/Personnages/Nya/preview 5.tscn")
	#s._Spell5 = load("res://Scenes/Personnages/Aventurier/4.tscn")
	s._Spell6 = load("res://Scenes/Personnages/Nya/preview 6.tscn")

	s.Hp = 1000
	s.MaxHp = 1000
	s.Death = false
	s.speed = 2.75
	s.speedtick = s.speed

	s.Cd2 = 0
	s.Cd2Base = 80
	s.damage2 = 110
	s.Anim2 = false
	s.TwoOnClick = false

	s.Cd4 = 0
	s.Cd4Base = 170
	s.Anim4 = false
	s.damage4 = 40
	s.FourOnClick = false

	s.Cd5 = 0
	s.Cd5Base = 90
	s.Anim5 = false
	s.FiveOnClick = false

	s.Cd6 = 0
	s.Cd6Base = 480
	s.Anim6 = false
	s.damage6 = 125
	s.SixOnClick = false

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
	s.hitbox.collision_mask = 0b00000000000000000010
	s.taille = Vector2(7,25)

""" ===0=== """

func SelectAnim(s):
	if s.Death:
		s.Frame.animation = "ded"
		
	elif s.animCC == "SelfStun":
		s.Frame.animation = "Five"
		
	elif s.Anim2:
		if s.TwoOnClick == true:
			s.Frame.animation = "2 charge"
		else:
			s.Frame.animation = "2 tir"
			
	elif s.Anim4:
		if s.FourOnClick == true:
			s.Frame.animation = "5 charge"
		else:
			s.Frame.animation = "5 tir"
			
	elif s.Anim6:
		if s.SixOnClick == true:
			s.Frame.animation = "6 charge"
		else:
			s.Frame.animation = "6 tir"
	
	elif s.Anim5:
		s.Frame.animation = "4"
		
		
	elif s.MovementDown and not s.MovementRight and not s.MovementLeft:
		s.Frame.animation = "marche"
	elif s.MovementUp and not s.MovementRight and not s.MovementLeft:
		s.Frame.animation = "marche"
	elif s.MovementRight and not s.MovementDown and not s.MovementUp:
		s.Frame.animation = "marche"
	elif s.MovementLeft and not s.MovementDown and not s.MovementUp:
		s.Frame.animation = "marche"
	elif s.MovementDown and s.MovementLeft and not s.MovementRight and not s.MovementUp:
		s.Frame.animation = "marche"
	elif s.MovementUp and s.MovementRight and not s.MovementLeft and not s.MovementDown:
		s.Frame.animation = "marche"
	elif s.MovementRight and s.MovementDown and not s.MovementLeft and not s.MovementUp:
		s.Frame.animation = "marche"
	elif s.MovementLeft and s.MovementUp and not s.MovementRight and not s.MovementDown:
		s.Frame.animation = "marche"
	else:
		s.Frame.animation = "stand"

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
	if not s.Cd2 > 0:
		if Condition:# and s.FourOnClick == false:
			s.speedtick /= 2
			s.Anim2 = true
			s.TwoOnClick = true
			
		else:
			if s.TwoOnClick == true:
				Spell2_ = s._Spell2.instance()
				s.get_parent().add_child(Spell2_)
				Spell2_.Launch(Vector2(s.position.x, s.position.y), s.rotation_degrees, s.damage2, s.EnemyLayer)
				Spell2_.self_modulate = s.SpellColor
				s.TwoOnClick = false
				s.Cd2 = s.Cd2Base
			
	else:
		if s.Cd2 < s.Cd2Base-10:
			s.Anim2 = false

func Spell4(s, Condition):
	if not s.Cd4 > 0:
		if Condition:# and s.FourOnClick == false:
			if s.FourOnClick == false:
				s.speedtick /= 2
				s.Anim4 = true
				s.FourOnClick = true
				Spell4_ = s._Spell4.instance()
				s.add_child(Spell4_)
				Spell4_.Launch(s.rotation_degrees, s.damage4, s.EnemyLayer)
				Spell4_.self_modulate = s.SpellColor
			
		else:
			if s.FourOnClick == true:
				s.FourOnClick = false
				s.Cd4 = s.Cd4Base
			
	else:
		if s.Cd4 < s.Cd4Base-10:
			s.Anim4 = false

func Spell5(s, Condition):
	if Condition and not s.Cd5 > 0:# and s.TwoOnClick == false and s.FiveOnClick == false and s.SixOnClick == false:
		if s.hitbox.get_overlapping_areas():
			s.speedtick *= 1.8
			s.FiveOnClick = true
			s.Anim5 = true
		else:
			s.Anim5 = false
			s.Cd5 = s.Cd5Base
			
	else:
		s.Anim5 = false
		s.FiveOnClick = false
	
func Spell6(s, Condition):
	if not s.Cd6 > 0:
		if Condition:# and s.FourOnClick == false:
			if s.SixOnClick == false:
				s.speedtick /= 2
				s.Anim6 = true
				s.SixOnClick = true
				Spell6_ = s._Spell6.instance()
				s.add_child(Spell6_)
				Spell6_.Launch(s.rotation_degrees, s.damage6, s.EnemyLayer)
				Spell6_.self_modulate = s.SpellColor
			
		else:
			if s.SixOnClick == true:
				s.SixOnClick = false
				s.Cd6 = s.Cd6Base
			
	else:
		if s.Cd6 < s.Cd6Base-10:
			s.Anim6 = false

func Cooldown(s):
	if s.Cd2 > 0:
		s.Cd2 -= s.delta
	if s.Cd4 > 0:
		s.Cd4 -= s.delta
	if s.Cd5 > 0:
		s.Cd5 -= s.delta
	if s.Cd6 > 0:
		s.Cd6 -= s.delta
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

func tree_entered(s):
	pass
	
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
