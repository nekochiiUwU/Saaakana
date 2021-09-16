extends Node2D

func get_imput():
	if Input.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("Mouse Capture"):
		if Input.get_mouse_mode():
			Input.set_mouse_mode(0)
		else:
			Input.set_mouse_mode(2)

func SceneChange(Scene):
	get_parent().SceneChange("ChampSelect", Scene)

func _ready():
	Input.set_mouse_mode(0)

func _process(delta):
	get_imput()
