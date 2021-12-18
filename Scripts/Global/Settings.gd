extends Node2D

onready var Controles = $UI/Controles
onready var General = $UI/General
onready var Graphismes = $UI/Graphismes
onready var Sons = $UI/Sons

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
	get_parent().SceneChange("Settings", Scene)

func _ready():
	pass

func _process(_delta):
	get_imput()


func _on_General_pressed():
	pass # Replace with function body.


func _on_Controles_pressed():
	pass # Replace with function body.


func _on_Graphismes_pressed():
	pass # Replace with function body.


func _on_Sons_pressed():
	pass # Replace with function body.
