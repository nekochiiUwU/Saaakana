extends Node2D

onready var Game = preload("../../Scenes/Global/Game.tscn").instance()
var Launch = true

var Scenes = [
	["MainMenu", false, false],
	["GamemodeSelect", false, false],
	["ChampSelect", false, false],
	["MapSelect", false, false],
	["Game", true, false],
	["Pause", false, false],
	["Settings", false, false]]

func _process(delta):
	if Scenes[0][1]:
		pass
	if Scenes[0][2]:
		pass

	if Scenes[1][1]:
		pass
	if Scenes[1][2]:
		pass

	if Scenes[2][1]:
		pass
	if Scenes[2][2]:
		pass

	if Scenes[3][1]:
		pass
	if Scenes[3][2]:
		pass

	if Scenes[4][1]:
		get_tree().get_root().add_child(Game)
	if Scenes[4][2]:
		get_tree().get_root().add_child(Game)

	if Scenes[5][1]:
		pass
	if Scenes[5][2]:
		pass

	if Scenes[6][1]:
		pass
	if Scenes[6][2]:
		pass

func SceneChange(OldScene = "Game", Scene = "Game"):
	if OldScene != Scene:
		for item in Scenes:
			if Scene in Scenes:
				Scenes[item][1] = true
			elif OldScene in Scenes:
				Scenes[OldScene][2] = true
