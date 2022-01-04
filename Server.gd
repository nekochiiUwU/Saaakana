extends Node

var SERVER_PORT = 6969
var MAX_PLAYERS = 2
var registred_players: Array = []

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)

func _process(delta):
	print(registred_players)
