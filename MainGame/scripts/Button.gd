extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _button_pressed():
	var shotangle = deg_to_rad(float(get_parent().get_node("Angle").text))
	var shotpower = float(get_parent().get_node("Power").text)
	get_tree().get_root().get_node("MainGame/Ball").strike(shotangle,shotpower)
	
