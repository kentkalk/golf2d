extends Node2D

var HazardType = LevelGenerator.HazardType

func _ready():
	# Configure camera bounds
	get_node("Camera2D").limit_left = 0
	get_node("Camera2D").limit_right = GameManager.currentlevel.get_width()
		

func _input(event):
	# Load In Game Menu
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		get_node("InGameMenu").visible = true
		
func _process(delta):
	# Move camera to follow ball
	get_node("Camera2D").position.x = get_node("Player/Ball").position.x
