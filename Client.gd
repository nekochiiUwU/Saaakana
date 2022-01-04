extends Node


var socket = PacketPeerUDP.new()
var PORT = 4242
var peer_ip = "87.89.177.64"
var data: Array
var is_online = false

func connect_peer():
	socket.set_dest_address(peer_ip, PORT)
	is_online = true

func disconnect_peer():
	socket.put_packet("Disconnect".to_ascii())
	socket = PacketPeerUDP.new()
	is_online = false


func _process(delta):
	if is_online:
		data = [
			Input.is_action_pressed("Up"),
			Input.is_action_pressed("Down"),
			Input.is_action_pressed("Right"),
			Input.is_action_pressed("Left")
		]
		for i in data:
			i = int(i)
		socket.put_packet(str(data).to_ascii())
	else:
		connect_peer()
