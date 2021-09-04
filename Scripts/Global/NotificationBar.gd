extends ColorRect

onready var Bar = $Bar
onready var Text = $Text

var Name = ""
var Value = 0
var MaxValue = 100
var Time = 100

func _process(_delta):
	Bar.set_size(Vector2((Value / MaxValue) * 100, 2))
	Text.set_text(Name)
	Time -= 1

# == V = Called with Camera's Script = V ==

func Pop(N, V, MV, T, Pos):
	Name = N
	Value = V
	MaxValue = MV
	Time = T
	rect_position = Pos

func Kill():
	queue_free()

func Replace(Pos):
	rect_position = Pos
