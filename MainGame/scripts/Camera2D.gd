extends Camera2D

const mousescrollspeed = 25
# Called when the node enters the scene tree for the first time.
func _ready():
	self.limit_left = 0
	self.limit_right = get_parent().get_node("Ground").width

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Scrolls camera, follows ball if it is moving, otherwise follows mouse if at edge of screen
	if (get_parent().get_node("Ball").freeze == false):
		self.position.x = get_parent().get_node("Ball").position.x
	else:
		# This mouse scrolling really doesn't work well....consider revisiting
		var mousex = get_viewport().get_mouse_position().x
		var leftscrollarea = get_viewport().size.x * 0.05
		var rightscrollarea = get_viewport().size.x * 0.95
		if (mousex < leftscrollarea):
			self.position.x = self.position.x - mousescrollspeed
			
		if (mousex > rightscrollarea):
			self.position.x = self.position.x + mousescrollspeed
