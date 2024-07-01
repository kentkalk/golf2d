extends Line2D

func _ready():
	# draw fill and collision polygons
	var fillvects = CustomUtils.closepoly_to_y(points, get_viewport_rect().size.y / 2)
	get_node("StaticBody2D/Polygon2D").set_polygon(fillvects)
	get_node("StaticBody2D/CollisionPolygon2D").set_polygon(fillvects)
