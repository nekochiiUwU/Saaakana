extends KinematicBody2D

#temp
var _x = 5
var _y = 5
var locked = false
var rightt
var leftt
var upp
var downn
var lockk

func get_inputs():
	
	if Input.is_action_pressed("Move Right"):
		if not rightt:
			move_and_collide(Vector2(+_x, 0))
			rightt = false
	else:
		rightt = true
	
	if Input.is_action_pressed("Move Left"):
		if not leftt:
			move_and_collide(Vector2(-_x, 0))
			leftt = false
	else:
		leftt = true
		
	if Input.is_action_pressed("Move Up"):
		if not upp:
			move_and_collide(Vector2(0, -_y))
			upp = false
	else:
		upp = true
		
	if Input.is_action_pressed("Move Down"):
		if not downn:
			move_and_collide(Vector2(0, +_y))
			downn = false
	else:
		downn = true
	
	if Input.is_action_pressed("Spell0"):
		if lockk:
			if locked:
				locked = false
				lockk = false
			else:
				locked = true
				lockk = false
		else:
			lockk = true
	


func _ready():
	pass

func _process(delta):
	get_inputs()
	
