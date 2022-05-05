extends Sprite

func _process(delta):
	rotation_degrees -= get_parent().get_parent().speed*90*delta
