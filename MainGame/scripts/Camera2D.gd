extends Camera2D

@export var screen_scroll_speed: float = 50.0
@export var min_viewport: float = 0.0
@export var max_viewport: float = 5120.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Camera scrolling side to side by mouse	
	var mousex = get_viewport().get_mouse_position().x
	var screenwidth = get_viewport().size.x
	
	if mousex < (screenwidth * 0.05):
		offset.x = offset.x	- screen_scroll_speed
		
	if mousex > (screenwidth * 0.95):
		offset.x = offset.x + screen_scroll_speed
		
	if offset.x < min_viewport:
		offset.x = min_viewport
		
	if offset.x > max_viewport:
		offset.x = max_viewport
