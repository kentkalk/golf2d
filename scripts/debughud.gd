extends CanvasLayer

func _ready():
# Show Debug HUD 
	if GameManager.debugmode:
		show()
	else:
		self.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	get_node("RenderStats").text = str(Engine.get_frames_per_second()) + " FPS"
	get_node("BallStats").text = "Ball Velocity: " + str(get_tree().get_root().get_node("Golf2D/MainGame/Ball").linear_velocity)
