extends Node2D

var online_update_active = true
var online_update_ended = [true, true]
var online_update_data = [0, [[-100, -100], [100, 100], 1000, 1000]]

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
	online_update_ended = [false, false]
	online_update_active = false
	$In.request("https://sakana.tremisabdoul.go.yj.fr/Games.json")
	online_update_data[1][3] += 0.0001
	$Out.send("https://sakana.tremisabdoul.go.yj.fr/Games.json", online_update_data[1])
	print("\nUpdate online data:\n", online_update_data[1], '\nAccess denied with code 403 (phase 2). Match of "rx ^0$" against "REQUEST_HEADERS:Content-Length" required.')
	online_update_active = true

func _process(delta):
	get_imput()
