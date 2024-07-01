extends CanvasLayer

func _ready():
	# Connect buttons
	get_node("SwingOverride/Button").pressed.connect(_override_pressed)
	get_node("SwingOverride/ResetButton").pressed.connect(_reset_pressed)
	
	# Show Debug HUD 
	if GameManager.debugmode:
		show()
	else:
		self.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	get_node("Stats/Render").text = str(Engine.get_frames_per_second()) + " FPS"
	get_node("Stats/Ball").text = "Ball Linear Velocity: " + str(get_tree().get_root().get_node("Golf2D/MainGame/Player/Ball").linear_velocity.length()) + \
		"\nBall Angular Velocity: " + str(get_tree().get_root().get_node("Golf2D/MainGame/Player/Ball").angular_velocity)
	get_node("Stats/Shot").text = "Shot Angle: " + str(get_tree().get_root().get_node("Golf2D/MainGame/Player").shot_angle) + \
		" Power: " + str(get_tree().get_root().get_node("Golf2D/MainGame/Player").shot_power)
		
func _override_pressed():
	get_tree().get_root().get_node("Golf2D/MainGame/Player").shot_angle = float(get_node("SwingOverride/AngleText").text)
	get_tree().get_root().get_node("Golf2D/MainGame/Player").shot_power = float(get_node("SwingOverride/PowerText").text)
	
func _reset_pressed():
	get_tree().get_root().get_node("Golf2D/MainGame/Player/Ball").reposition_ball(GameManager.currentlevel.get_ballstartposition())
