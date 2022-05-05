extends Node2D

onready var MainMenu = preload("../../Scenes/Global/MainMenu.tscn").instance()
onready var GamemodeSelect = preload("../../Scenes/Global/GamemodeSelect.tscn").instance()
onready var ChampSelect = preload("../../Scenes/Global/ChampSelect.tscn").instance()
onready var MapSelect = preload("../../Scenes/Global/MapSelect.tscn").instance()
onready var Game = preload("../../Scenes/Global/Game.tscn").instance()
onready var Pause = preload("../../Scenes/Global/Pause.tscn").instance()
onready var Settings = preload("../../Scenes/Global/Settings.tscn").instance()

var Launch = true
var Champs = ["",""]

var Scenes = [
	["MainMenu", true, false],
	["GamemodeSelect", false, false],
	["ChampSelect", false, false],
	["MapSelect", false, false],
	["Game", false, false],
	["Pause", false, false],
	["Settings", false, false]
	]

func _process(_delta):
	if Scenes[0][1]:
		add_child(MainMenu)
		Scenes[0][1] = false
	if Scenes[0][2]:
		remove_child(MainMenu)
		Scenes[0][2] = false

	if Scenes[1][1]:
		add_child(GamemodeSelect)
		Scenes[1][1] = false
	if Scenes[1][2]:
		remove_child(GamemodeSelect)
		Scenes[1][2] = false

	if Scenes[2][1]:
		add_child(ChampSelect)
		Scenes[2][1] = false
	if Scenes[2][2]:
		remove_child(ChampSelect)
		Scenes[2][2] = false

	if Scenes[3][1]:
		add_child(MapSelect)
		Scenes[3][1] = false
	if Scenes[3][2]:
		remove_child(MapSelect)
		Scenes[3][2] = false

	if Scenes[4][1]:
		add_child(Game)
		Scenes[4][1] = false
	if Scenes[4][2]:
		remove_child(Game)
		Scenes[4][2] = false

	if Scenes[5][1]:
		add_child(Pause)
		Scenes[5][1] = false
	if Scenes[5][2]:
		remove_child(Pause)
		Scenes[5][2] = false

	if Scenes[6][1]:
		add_child(Settings)
		Scenes[6][1] = false
	if Scenes[6][2]:
		remove_child(Settings)
		Scenes[6][2] = false

func SceneChange(OldScene = "Game", Scene = "Pause"):
	if OldScene != Scene:
		for item in Scenes:
			if OldScene == item[0]:
				item[2] = true
		for item in Scenes:
			if Scene == item[0]:
				item[1] = true
	if OldScene == "ChampSelect" and Scene == "Game":
		Game.queue_free()
		Game = load("res://Scenes/Global/Game.tscn").instance()
		#$Game.set_script(load("res://Scripts/Global/Game.gd"))
