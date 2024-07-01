extends Node2D

var left_coord : Vector2
var right_coord : Vector2
var width : float
var height : float

func _ready():
	# calculate width and height for use often later
	width = right_coord.x - left_coord.x
	height = get_viewport_rect().size.y / 2 - left_coord.y
	
	# move element to correct generated position
	translate(left_coord)
	
	# draw leading curve
	var leadingpoints = CustomUtils.line_to_curve(Vector2.ZERO, Vector2(150,0), Vector2(200, height), Vector2.ZERO)
	var leadline = Line2D.new()
	leadline.points = leadingpoints
	leadline.default_color = Color.ROSY_BROWN
	add_child(leadline)
	var leadpolyvertex = CustomUtils.closepoly_to_y(leadingpoints, height)
	var leadpoly = Polygon2D.new()
	leadpoly.set_polygon(leadpolyvertex)
	leadpoly.color = Color.hex(0x1d9573ff)
	add_child(leadpoly)
	var leadcollision = CollisionPolygon2D.new()
	leadcollision.set_polygon(leadpolyvertex)
	add_child(leadcollision)
	
	
	# draw trailing curve
	var trailingpoints =  CustomUtils.line_to_curve(Vector2(width, 0), Vector2(-150, 0), Vector2(width-200, height), Vector2.ZERO)
	var trailline = Line2D.new()
	trailline.points = trailingpoints
	trailline.default_color = Color.ROSY_BROWN
	add_child(trailline)
	var trailpolyvertex = CustomUtils.closepoly_to_y(trailingpoints, height)
	var trailpoly = Polygon2D.new()
	trailpoly.set_polygon(trailpolyvertex)
	trailpoly.color = Color.hex(0x1d9573ff)
	add_child(trailpoly)
	var trailcollision = CollisionPolygon2D.new()
	trailcollision.set_polygon(trailpolyvertex)
	add_child(trailcollision)
	
	# resize the water block
	get_node("WaterTexture").size = Vector2(width, height)


# called by the level to draw this element
func set_points(in_points):
	left_coord = in_points[0]
	in_points.reverse()
	right_coord = in_points[0]
