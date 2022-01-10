extends Node

var SERVER_IP = '127.0.0.1'
var SERVER_PORT = 62319
const MAX_PLAYERS = 5

var players = {}
var self_data: Dictionary = {
	name = '',
	position = Vector2(300, 300)
}

func create_server(player_name):
	self_data.position.x = rand_range(100, 1820)
	self_data.position.y = rand_range(100, 980)
	self_data.name = player_name
	players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	print("IP:\t", IP.get_local_addresses()[1], "\nPort:\t", SERVER_PORT)
	print(peer.get_connection_status())
	get_tree().network_peer = peer

func connect_to_server(player_name):
	self_data.position.x = rand_range(100, 1820)
	self_data.position.y = rand_range(100, 980)
	self_data.name = player_name
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

func _connected_to_server():
	players[get_tree().get_network_unique_id()] = self_data
	rpc('_send_player_info', get_tree().get_network_unique_id(), self_data)

func update_position(id, position):
	players[id].position = position

remote func _send_player_info(id, info):
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id, '_send_player_info', peer_id, players[peer_id])
	players[id] = info
	var new_player = load('res://Player.tscn').instance()
	new_player.name = str(id)
	new_player.set_network_master(id)
	get_tree().get_root().add_child(new_player)
	new_player.init(info.name, info.position, true)

func _ready():
	print("ready")

func _process(delta):
	pass#print(players)
