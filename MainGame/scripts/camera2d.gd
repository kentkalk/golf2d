extends Camera2D

@export var mouse_scroll_margin = 0.10
@export var mouse_scroll_speed = 50.0
var _mouse_scroll_lbound
var _mouse_scroll_rbound

func _ready():
	# Configure camera bounds
	limit_left = 0
	limit_right = GameManager.current_level.get_width()
	
	# Configure mouse scrolling
	_mouse_scroll_lbound = get_viewport_rect().size.x * mouse_scroll_margin
	_mouse_scroll_rbound = get_viewport_rect().size.x * (1 - mouse_scroll_margin)

func _process(delta):
	if get_parent().get_node("Player/Ball").sleeping:
		var mousex = get_viewport().get_mouse_position().x
		if mousex < _mouse_scroll_lbound:
			position.x = max(limit_left, position.x - mouse_scroll_speed)		
		if mousex > _mouse_scroll_rbound:
			position.x = min(limit_right, position.x + mouse_scroll_speed)
	else:
		position = get_parent().get_node("Player/Ball").position
