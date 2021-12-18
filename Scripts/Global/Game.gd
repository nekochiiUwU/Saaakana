extends Node2D

var online_update_active = true
var online_update_data = []
func get_imput():
	if Input.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("Mouse Capture"):
		if Input.get_mouse_mode():
			Input.set_mouse_mode(0)
		else:
			Input.set_mouse_mode(2)
	if Input.is_action_just_pressed("Quit"):
		SceneChange("Pause")

func SceneChange(Scene):
	get_parent().SceneChange("Game", Scene)

func _ready():
	online_update()
	Input.set_mouse_mode(0)

func online_update():
	$HTTPRequest.request("https://sakana.tremisabdoul.go.yj.fr/Games.json")

func _process(delta):
	print(online_update_data)
	get_imput()
