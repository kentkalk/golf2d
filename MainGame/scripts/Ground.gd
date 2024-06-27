extends StaticBody2D

#public variables
@export var level_width: float = 0  #width of generated level
@export var teebox_start_pos = Vector2(0,0)  #where ball spawns initially

# configuration constants
const fairwaycolor = Color.WEB_GREEN
const greencolor = Color.DARK_GREEN
const fillcolor = Color.MEDIUM_SEA_GREEN
const sectionwidth = 80

# calculated variables
var screenbottom

# enums
enum hazardtype {TEEBOX, FAIRWAY, WATER}

# Called when the node enters the scene tree for the first time.
func _ready():
	screenbottom = get_viewport_rect().size.y / 2
	
	const par = 3
	const coursebegin = Vector2(-1280,400)
	
	var startcoord = coursebegin
	var nextcoord = Vector2(coursebegin.x + sectionwidth, coursebegin.y)
	
	# This is just a test of course hazards, will be generated algorithmically later
	
	# Tee Box
	startcoord = hole_section(startcoord, hazardtype.TEEBOX)

	# Basic Fairway pt.1 	
	for i in range(par):
		startcoord = hole_section(startcoord, hazardtype.FAIRWAY)
	
	# Water hazard
	startcoord = hole_section(startcoord, hazardtype.WATER, -50)
		
	# Basic Fairway pt.2 	
	for i in range(par):
		startcoord = hole_section(startcoord, hazardtype.FAIRWAY)

	# only to make the green generate in the correct location until rewritten
	nextcoord = Vector2(startcoord.x + sectionwidth, startcoord.y)

	# Green
	draw_groundpolys(startcoord, nextcoord, 50, fairwaycolor, fillcolor)
	startcoord = Vector2(nextcoord.x, nextcoord.y + 5)
	nextcoord = Vector2(nextcoord.x + sectionwidth, nextcoord.y + 5)
	level_width = level_width + sectionwidth
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
		level_width = level_width + sectionwidth
	startcoord.y = startcoord.y - 5
	nextcoord.y = nextcoord.y - 5
	draw_groundpolys(startcoord, nextcoord, 50, fairwaycolor, fillcolor)
	level_width = level_width + sectionwidth


# Function adds a section to the level
# each hole has one teebox, one green, and multiple hazard sections depending on hole par
func hole_section(start: Vector2, type: hazardtype, elevationoffset: float = 0):	
	var startcoord = start
	var nextcoord = start
	
	match type:

		hazardtype.TEEBOX:
			# configuration constants
			const groundthickness = 50  #thickness of ground layer on edges
			const boxthickness = 45  #thickness of ground layer under teebox
			const groundcolor = Color.WEB_GREEN #color of surrounding fairway
			const boxcolor = Color.DARK_OLIVE_GREEN #color of teebox itself
			
			# leading edge
			startcoord = Vector2(start.x, start.y + elevationoffset)
			nextcoord = Vector2(startcoord.x + (get_viewport_rect().size.x / 32), startcoord.y)
			draw_groundpolys(startcoord, nextcoord, groundthickness, groundcolor, fillcolor)
			
			# teebox
			startcoord = Vector2(nextcoord.x, nextcoord.y + (groundthickness - boxthickness))
			teebox_start_pos = Vector2(startcoord.x + ((get_viewport_rect().size.x / 5) / 2), startcoord.y)
			nextcoord = Vector2(startcoord.x + (get_viewport_rect().size.x / 5), startcoord.y)
			draw_groundpolys(startcoord, nextcoord, boxthickness, boxcolor, fillcolor)
			
			# trailing edge
			startcoord = Vector2(nextcoord.x, nextcoord.y - (groundthickness - boxthickness))
			nextcoord = Vector2(startcoord.x + (get_viewport_rect().size.x / 32), startcoord.y)
			draw_groundpolys(startcoord, nextcoord, groundthickness, groundcolor, fillcolor)
			
		hazardtype.FAIRWAY:
			# configuration constants
			const groundthickness = 50 #thickness of ground layer
			const groundcolor = Color.WEB_GREEN #color of ground layer
			const roughness = 5 #random roughness range
			const numberofpieces = 16 #number of pieces in a fairway section
			var piecewidth = (get_viewport_rect().size.x / 2) / numberofpieces
			
			# random fairway pieces
			for i in range(numberofpieces):
				nextcoord = Vector2(startcoord.x + piecewidth, startcoord.y + randf_range(-roughness, roughness) - elevationoffset)
				elevationoffset = 0
				draw_groundpolys(startcoord, nextcoord, groundthickness, groundcolor, fillcolor)
				startcoord = nextcoord
				
		hazardtype.WATER:
			# configuration constants
			const toplayerthickness = 100 #thickness of top layer of water
			const toplayercolor = Color.BLUE
			const bottomlayercolor = Color.DARK_BLUE
			const roughness = 15 #random roughness range
			const numberofpieces = 32 #number of pieces in a water section
			var piecewidth = (get_viewport_rect().size.x / 2) / numberofpieces
			
			# adjust for elevation offset one time, water sections are offset as one piece
			startcoord.y = startcoord.y - elevationoffset
			# random water pieces
			for i in range(numberofpieces):
				nextcoord = Vector2(startcoord.x + piecewidth, startcoord.y + randf_range(-roughness, roughness))
				draw_groundpolys(startcoord, nextcoord, toplayerthickness, toplayercolor, bottomlayercolor, false)
				startcoord = nextcoord
			# adjust elevation back
			nextcoord.y = nextcoord.y + elevationoffset
			
	level_width = level_width + (nextcoord.x - start.x)
	return nextcoord
	
# Function draws a top layer (the ground), the underlying fill layer, and the collision polygon
func draw_groundpolys(startloc: Vector2, nextloc: Vector2, topthickness: float, topcolor: Color, fillcolor: Color, collides: bool = true):
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
		
	self.add_child(drawpolytop)	
	if collides:
		self.add_child(collpolytop)	
	self.add_child(drawpolyfill)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
