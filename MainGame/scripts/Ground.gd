extends StaticBody2D

@export var width: float = 0
@export var teebox_start_pos = Vector2(0,0)

# configuration
const fairwaycolor = Color.WEB_GREEN
const teeboxcolor = Color.DARK_OLIVE_GREEN
const greencolor = Color.DARK_GREEN
const fillcolor = Color.MEDIUM_SEA_GREEN
const sectionwidth = 80 
const screenbottom = 720
const sectiondeviations = 8


# Called when the node enters the scene tree for the first time.
func _ready():
	
	const par = 5
	const coursebegin = Vector2(-1280,400)
	
	var startcoord = coursebegin
	var nextcoord = Vector2(coursebegin.x + sectionwidth, coursebegin.y)
	
	# Tee Box
	draw_groundpolys(startcoord, nextcoord, 50, fairwaycolor, fillcolor)
	startcoord = Vector2(nextcoord.x, nextcoord.y + 5)
	nextcoord = Vector2(nextcoord.x + sectionwidth, nextcoord.y + 5)
	width = width + sectionwidth
	for i in range(6):
		draw_groundpolys(startcoord, nextcoord, 45, teeboxcolor, fillcolor)
		if (i == 2):
			teebox_start_pos = nextcoord
		startcoord = nextcoord
		nextcoord = Vector2(nextcoord.x + sectionwidth, nextcoord.y)
		width = width + sectionwidth
	startcoord.y = startcoord.y - 5
	nextcoord.y = nextcoord.y - 5
	draw_groundpolys(startcoord, nextcoord, 50, fairwaycolor, fillcolor)
	startcoord = nextcoord
	nextcoord = Vector2(nextcoord.x + sectionwidth, nextcoord.y)
	width = width + sectionwidth
	
	# Basic Fairway	
	for i in range(32 * par):
		draw_groundpolys(startcoord, nextcoord, 50, fairwaycolor, fillcolor)
		startcoord = nextcoord
		nextcoord = Vector2(nextcoord.x + sectionwidth, nextcoord.y + randf_range(-15,15))
		width = width + sectionwidth

	# Green
	draw_groundpolys(startcoord, nextcoord, 50, fairwaycolor, fillcolor)
	startcoord = Vector2(nextcoord.x, nextcoord.y + 5)
	nextcoord = Vector2(nextcoord.x + sectionwidth, nextcoord.y + 5)
	width = width + sectionwidth
	var holelocation = randi_range(2,9)
	for i in range(12):
		if (i == holelocation):
			startcoord.y = startcoord.y + 45
			nextcoord.y = nextcoord.y + 45
			draw_groundpolys(startcoord, nextcoord, 45, fillcolor, fillcolor)
			startcoord.y = startcoord.y - 45
			nextcoord.y = nextcoord.y - 45
		else:
			draw_groundpolys(startcoord, nextcoord, 45, greencolor, fillcolor)
		startcoord = nextcoord
		nextcoord = Vector2(nextcoord.x + sectionwidth, nextcoord.y)
		width = width + sectionwidth
	startcoord.y = startcoord.y - 5
	nextcoord.y = nextcoord.y - 5
	draw_groundpolys(startcoord, nextcoord, 50, fairwaycolor, fillcolor)
	width = width + sectionwidth




# Function draws a top layer (the ground), the underlying fill layer, and the collision polygon
func draw_groundpolys(startloc: Vector2, nextloc: Vector2, topthickness: float, topcolor: Color, fillcolor: Color):
	var toppoly = PackedVector2Array([startloc, nextloc, Vector2(nextloc.x, nextloc.y + topthickness), Vector2(startloc.x, startloc.y + topthickness)])
	var fillpoly = PackedVector2Array([Vector2(startloc.x, startloc.y + topthickness), Vector2(nextloc.x, nextloc.y + topthickness), Vector2(nextloc.x, screenbottom), Vector2(startloc.x, screenbottom)])
	
	var drawpolytop = Polygon2D.new()
	var drawpolyfill = Polygon2D.new()
	var collpolytop = CollisionPolygon2D.new()

	drawpolytop.set_polygon(toppoly)
	drawpolyfill.set_polygon(fillpoly)
	collpolytop.set_polygon(toppoly)
	drawpolytop.color = topcolor
	drawpolyfill.color = fillcolor
	
	print (toppoly)
	print (fillpoly)
		
	self.add_child(drawpolytop)	
	self.add_child(collpolytop)	
	self.add_child(drawpolyfill)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
