extends AnimatedSprite
onready var select = get_parent().get_child(0)
onready var cursor2 = get_parent().get_parent().get_child(1).get_child(1)

var _x = 92
var _y = 92
var locked = false
var lock
var selected = ""
var ModulateReset = 1
var Modcringe = 0
var MaxModCringe = 0


func get_inputs():
	if not selected:
		if Input.is_action_just_pressed("Move Right") and position.x < 848:
			position.x += _x
			checkChamp()
				
		if Input.is_action_just_pressed("Move Left") and position.x > 572:
			position.x -= _x
			checkChamp()
			
		if Input.is_action_just_pressed("Move Up") and position.y > 352:
			position.y -= _y
			checkChamp()
			
		if Input.is_action_just_pressed("Move Down") and position.y < 996:
			position.y += _y
			checkChamp()
	
	if Input.is_action_just_pressed("Spell0"):
			if selected:
				MaxModCringe = 50
				Modulate(Color(1,1,1), MaxModCringe, 1)
				animation = "free"
				selected = ""
				
			else:
				selected = checkChamp()
				animation = "lock"
				MaxModCringe = 200
				Modulate(Color(1,1,1), MaxModCringe, 10)
	
	
func checkChamp():
	if position == Vector2(848,352):
		select.animation = "Archer"
		return "Archer"
		
	elif position == Vector2(848,444):
		select.animation = "Aventurier"
		return "Aventurier"
	
	elif position == Vector2(848,536):
		select.animation = "Nya"
		return "Nya"
	
	elif position == Vector2(848,628):
		select.animation = "Sniper"
		return "Sniper"
		
	else:
		select.animation = "none"
	
func Modulate(Mod, Modcring, Reset):
	select.modulate = Color(Mod)
	Modcringe = Modcring
	ModulateReset = Reset
	
func _ready():
	position = Vector2(848,352)
	checkChamp()

func _process(delta):
	get_inputs()
	if cursor2.selected and selected:
		if lock > 0:
			lock -= delta*60
			get_viewport().get_child(0).get_child(0).get_child(0).get_child(3).text = str(abs(round(lock/1.8)))
		else:
			get_viewport().get_child(0).Champs = [selected, cursor2.selected] 
			selected = ""
			cursor2.selected = ""
			get_viewport().get_child(0).SceneChange("ChampSelect", "Game")
	else:
		lock = 180
		get_viewport().get_child(0).get_child(0).get_child(0).get_child(3).text = "UwU"
	if Modcringe > 0:
		Modulate(Color((100+Modcringe)/100,(100+Modcringe)/100,(100+Modcringe)/100), Modcringe, ModulateReset)
		Modcringe -= delta*60*(Modcringe/ModulateReset)
		if Modcringe < 0:
			select.modulate = Color(1,1,1)
