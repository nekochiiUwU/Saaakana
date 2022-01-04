extends Node

var socket = PacketPeerUDP.new()

var PORT = 4242
var peer_ip = "*"
var data: Array
var is_online = false
var is_searching_peer = true

onready var image = get_node("icon")

func listen_port():
	var result = socket.listen(PORT, peer_ip)
	if result != OK:
		print("An error occurred listening on port ", PORT)
	else:
		print("Listening on port", PORT, "on localhost")
	if result == OK:
		is_searching_peer = false
		is_online = true

func disconnect_peer():
	socket = PacketPeerUDP.new()
	is_online = false
	is_searching_peer = true


func _process(delta):
	if is_online:
		if socket.get_available_packet_count() > 0:
			var data = socket.get_packet().get_string_from_ascii()
			
			
			var script = GDScript.new()
			script.set_source_code("func eval(data):\n\tdata = " + data + "\n\tfor i in data:\n\t\ti = int(i)\n\treturn data")
			script.reload()

			var obj = Reference.new()
			obj.set_script(script)

			data = obj.eval(data) # Supposing input is "23 + 2", returns 25
			
			for i in data:
				i = int(i)
			print(data)
			if data == "Disconnect":
				disconnect_peer()
			else:
				print(data[2])
				if data[2] == "0":
					image.position.x += 1
	elif is_searching_peer:
		listen_port()
