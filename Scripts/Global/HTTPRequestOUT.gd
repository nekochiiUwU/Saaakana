extends HTTPRequest

var content_length = "Content-Length: 28"

func _ready():
	set_use_threads(true)
	connect("request_completed", self, "post")

func post(a, b, c, d):
	print(a, "\n", b, "\n", c, "\n", d)
	for i in d: print(i)
	content_length = c[5]

func send(url = "https://sakana.tremisabdoul.go.yj.fr/Games.json", data = [0, 0], use_ssl = false):
	var out = ";"
	if data:
		for i in range(len(data)):
			if typeof(data[i]) == TYPE_ARRAY:
				for ii in range(len(data[i])):
					out += str(data[i][ii])
					if ii != len(data[i])-1:
						out += "/"
			else:
				out += str(data[i])
			if i != len(data)-1:
				out += ","
		#print(out)
		var headers = ["Content-Type: application/json",
					   "Accept: */*",
					   content_length]
		print(headers)
		#method_put
		request(url, headers, use_ssl, HTTPClient.METHOD_POST, to_json(out))
		get_parent().online_update_ended[1] = true
		if get_parent().online_update_ended[0] and get_parent().online_update_ended[1] and get_parent().online_update_active:
			get_parent().online_update()
