extends Node
var array = []

var frame = 0


func init_array(size):
	for y in range(size[0]):
		array.append([])
		for z in range(size[1]):
			array[y].append([])
			for x in range(size[2]):
				if z == 0:
					array[y][z].append(int(rand_range(0, 7)))
				elif z == 1:
					if x == 0:
						array[y][z].append(100)
					else:
						array[y][z].append(1000)
	for y in array:
		for z in y:
			for x in range(size[2]):
				if z == y[0]:
					z[x] = int(rand_range(0, 7))
				elif z == y[1]:
					if x == 0:
						z[x] = 100
					else:
						z[x] = 1000
	return array


func random_array(situations):
	var total = []

	for y in range(len(array)):
		var y_points = array[y][1][0]
		for situation in situations:
			if situation:
				if array[y][1][situation] > 0:
					y_points *= array[y][1][situation] / 1000
				else:
					y_points = 0

		y_points = int(y_points) + 1
		for i in range(y_points):
			total.append(y)
		#del y_points
	return array[total[int(rand_range(0, len(total) - 1))]]
	

func update():
	var selected_y = random_array([])
	print(str(selected_y))
	#time.sleep(0.2+t)


func printer():
	print("\n\n--------------------------------------------\n\nTableau:\n")
	# for y in array:
	#    print(y)
	print(array)

func _ready():
	array = init_array(Vector3(10000, 2, 10))

func _process(_delta):
	if not frame % 10:
		
		update()
	frame += 1
	if not frame % 100:
		printer()
		pass
