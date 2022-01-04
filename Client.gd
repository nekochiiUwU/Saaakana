extends Node


var socket = PacketPeerUDP.new()
var PORT = 4242
var peer_ip = "172.17.29.117"
var data: Array
var is_online = false

func connect_peer():
	socket.set_dest_address(peer_ip, PORT)
	is_online = true

func disconnect_peer():
	socket.put_packet("Disconnect".to_ascii())
	socket = PacketPeerUDP.new()
	is_online = false

func mowows(data, n = 0):
	var owosep = ["|", ";", ":", ","]
	var owo = ""
	var owolst
	for i in data:
		owolst = i
	for i in data:
		if not i is Array:
			if typeof(i) == typeof(true):
				i = int(i)
			elif typeof(i) == typeof(1.1):
				i = round(i*100)/100
			if i != owolst:
				owo += str(i) + owosep[n]
			else:
				owo += str(i)
		else:
			owo += mowows(i)
			if i != owolst:
				owo += owosep[n]
	print(owo)
	return owo
func _process(delta):
	if is_online:
		data = [
			int(Input.is_action_pressed("Up")),
			int(Input.is_action_pressed("Down")),
			int(Input.is_action_pressed("Right")),
			int(Input.is_action_pressed("Left"))
		]
		socket.put_packet((mowows(data)).to_ascii())
	else:
		connect_peer()
