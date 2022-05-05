extends AnimatedSprite
onready var select = get_parent().get_child(0)

#temp
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
		if Input.is_action_just_pressed("Move Right 2") and position.x < 1348:
			position.x += _x
			checkChamp()
				
		if Input.is_action_just_pressed("Move Left 2") and position.x > 1072:
			position.x -= _x
			checkChamp()
			
		if Input.is_action_just_pressed("Move Up 2") and position.y > 352:
			position.y -= _y
			checkChamp()
			
		if Input.is_action_just_pressed("Move Down 2") and position.y < 996:
			position.y += _y
			checkChamp()
	
	if Input.is_action_just_pressed("Spell0 2"):
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
				lock = 180
				
				
func checkChamp():
	if position == Vector2(1072,352):
		select.animation = "Archer"
		return "Archer"
		
	elif position == Vector2(1072,444):
		select.animation = "Aventurier"
		return "Aventurier"
	
	elif position == Vector2(1072,536):
		select.animation = "Nya"
		return "Nya"
	
	elif position == Vector2(1072,628):
		select.animation = "Sniper"
		return "Sniper"
	
	elif position == Vector2(1072,720):
		select.animation = "Mystique"
		return "Mystique"
		
	
	else:
		select.animation = "none"

func Modulate(Mod, Modcring, Reset):
	select.modulate = Color(Mod)
	Modcringe = Modcring
	ModulateReset = Reset

func _ready():
	position = Vector2(1072,352)
	checkChamp()

func _process(delta):
	get_inputs()
	if Modcringe > 0:
		Modulate(Color((100+Modcringe)/100,(100+Modcringe)/100,(100+Modcringe)/100), Modcringe, ModulateReset)
		Modcringe -= delta*60*(Modcringe/ModulateReset)
		if Modcringe < 0:
			select.modulate = Color(1,1,1)
