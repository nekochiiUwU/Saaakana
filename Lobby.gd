extends Node

onready var player_name = get_node("PlayerName")
var ip = ""

func _on_Create_pressed():
	if player_name.text != '':
		Network.create_server(player_name.text)
		get_tree().change_scene("res://Game.tscn")

func _on_Join_pressed():
	if player_name.text != '':
		Network.connect_to_server(player_name.text)
		get_tree().change_scene("res://Game.tscn")
