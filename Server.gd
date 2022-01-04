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
			var dataarray = []
			data = data.split("|")
			dataarray = Array()
			for i in data:
				dataarray.append(i)

			for i in dataarray:
				dataarray = i.split(";")
				data = Array()
				for iwi in dataarray:
					data.append(iwi)
			for i in data:
				for iwi in i:
					iwi = iwi.split(":")
					dataarray = Array()
					for iwiowo in data:
						dataarray.append(iwiowo)
			print(dataarray)
			if typeof(dataarray) == typeof(""):
				disconnect_peer()
			else:
				print(dataarray[2])
				if dataarray[2] == "0":
					image.position.x += 1
	elif is_searching_peer:
		listen_port()
