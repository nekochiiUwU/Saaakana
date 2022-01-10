extends KinematicBody2D

var speed = 1000.0
var max_hp = 100
var hp = max_hp
var vector = Vector2()
slave var online = {'position': Vector2()}

func local_process(delta):
	var movedition = [Input.is_action_pressed("Move Right"), Input.is_action_pressed("Move Left"), Input.is_action_pressed("Move Down"), Input.is_action_pressed("Move Up")]
	if movedition[0]:
		vector.x += speed
	if movedition[1]:
		vector.x -= speed
	if movedition[2]:
		vector.y += speed
	if movedition[3]:
		vector.y -= speed
	move_and_collide(vector * delta)
	vector = Vector2()

func send_variables():
	var send = {
		'position': position
	}
	rset_unreliable('online', send)

func set_variables():
	position = online['position']

func init(nickname, start_position, is_slave):
	global_position = start_position

func _process(delta):
	if is_network_master():
		local_process(delta)
		send_variables()
	else:
		set_variables()
	if get_tree().is_network_server():
		Network.update_position(int(name), position)
