extends Sprite

var index
var player

func Launch(i, p):
	index = i
	player = p

func _process(_delta):
	position = player.last6[index]
