extends Node2D

onready var Game = preload("res://Scenes/Global/Game.tscn").instance()
var Launch = true
var Scenes = {
	"MainMenu": [false, 0],
	"GamemodeSelect": [false, 0],
	"ChampSelect": [false, 0],
	"MapSelect": [false, 0],
	"Game": [true, Game],
	"Pause": [false, 0],
	"Settings": [false, 0]}

func _ready():
	while Launch:
		if Scenes["MainMenu"][0]:
			while Scenes["MainMenu"][0]:
				pass
		if Scenes["GamemodeSelect"][0]:
			while Scenes["GamemodeSelect"][0]:
				pass
		if Scenes["ChampSelect"][0]:
			while Scenes["ChampSelect"][0]:
				pass
		if Scenes["MapSelect"][0]:
			while Scenes["MapSelect"][0]:
				pass
		if Scenes["Game"][0]:
			add_child(Scenes["Game"][1])
			while Scenes["Game"][0]:
				pass
			remove_child(Scenes["Game"][1])
		if Scenes["Pause"][0]:
			while Scenes["Pause"][0]:
				pass
		if Scenes["Settings"][0]:
			while Scenes["Settings"][0]:
				pass

func SceneChangeTo(OldScene = "Game", Scene = "Game"):
	if OldScene != Scene:
		Scenes[Scene][0] = true
		Scenes[OldScene][0] = false
