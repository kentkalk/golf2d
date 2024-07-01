extends Node2D

var _points

func _ready():
	translate(_points[0])

func set_points(in_points):
	_points = in_points

# called to convert a line into a polygon filled to the bottom of screen
func closepoly_to_screenbottom(in_vects):
	var screenbottom = get_viewport_rect().size.y / 2
	var out_vects = in_vects.duplicate()
	
	if in_vects.size() > 0:
		var bottomrightvector = in_vects[in_vects.size() - 1]
		var bottomleftvector = in_vects[0]
		bottomrightvector.y = screenbottom
		bottomleftvector.y = screenbottom
		out_vects.append(bottomrightvector)
		out_vects.append(bottomleftvector)
	
	return out_vects
