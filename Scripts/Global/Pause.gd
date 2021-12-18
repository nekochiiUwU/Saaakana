extends Node2D

onready var ContinueButton = $ContinueButton
onready var SettingsButton = $SettingsButton
onready var MainMenuButton = $MainMenuButton

func get_imput():
	if Input.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("Mouse Capture"):
		if Input.get_mouse_mode():
			Input.set_mouse_mode(0)
		else:
			Input.set_mouse_mode(2)
	if Input.is_action_just_pressed("Quit"):
		SceneChange("Game")

func SceneChange(Scene):
	get_parent().SceneChange("Pause", Scene)

func _ready():
	Input.set_mouse_mode(0)

func _process(_delta):
	get_imput()
	ContinueButton.set_position(Vector2(960, 540-200) - ContinueButton.get_size()/2)
	SettingsButton.set_position(Vector2(960, 540+0) - SettingsButton.get_size()/2)
	MainMenuButton.set_position(Vector2(960, 540+200) - MainMenuButton.get_size()/2)
	

func _on_ContinueButton_pressed():
	SceneChange("Game")


func _on_SettingsButton_pressed():
	SceneChange("Settings")


func _on_MainMenuButton_pressed():
	SceneChange("MainMenu")
