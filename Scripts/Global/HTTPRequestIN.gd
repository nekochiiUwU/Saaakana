extends HTTPRequest

func _ready():
	set_use_threads(true)
	connect("request_completed", self, "syncronise")

func syncronise(a, b, c, d):
	d = d.get_string_from_utf8()
	d = splitter(d)
	#print("\n", d)
	get_parent().online_update_data = d
	get_parent().online_update_ended[0] = true
	if get_parent().online_update_ended[0] and get_parent().online_update_ended[1] and get_parent().online_update_active:
		get_parent().online_update()
	#for i in range(len(d)):
	#	print("Game Data ", i, ":\t", d[i])

func splitter(d = "", n = 0):
	var separators = [";", ",", "/", "END SEPARATOR"]
	d = Array(d.split(separators[n]))
	for i in range(len(d)):
		if separators[n+1] in d[i]:
			d[i] = splitter(d[i], n+1)
		else:
			d[i] = float(d[i])
	return d
