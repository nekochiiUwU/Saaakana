extends ColorRect

onready var Bar = $Bar
onready var Text = $Text
onready var Cam = get_node("../../../../..")

var Name = ""
var Value = 100
var MaxValue = 100
var Time = 100
var Notif = 1
var Index = 0

func _process(delta):
	Bar.set_size(Vector2((Value / MaxValue) * 100, 1))
	Text.set_text(Name)
	if 0 > Time:
		Cam.Notifications["Displayed"].remove(Index)
		queue_free()
	Time -= 1


func Pop(N, V, MV, T):
	Name = N
	Value = V
	MaxValue = MV
	Time = T
	rect_position = Vector2(0, 100)
