extends Node2D

var HazardType = LevelGenerator.HazardType

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func draw_level():
	for currentpiece in GameManager.currentlevel:
		# Draw polygons
		match currentpiece.type:
			
			HazardType.FAIRWAY:
				# top line
				var drawline = Line2D.new()
				drawline.z_index = 1
				drawline.use_parent_material = true
				drawline.width = 25
				drawline.texture_mode = Line2D.LINE_TEXTURE_TILE
				drawline.points = currentpiece.line
				get_node("Fairway").add_child(drawline)
				
				# fill and collision polygons
				var fillvects = closepoly_to_screenbottom(currentpiece.line)
				var drawpoly = Polygon2D.new()
				drawpoly.set_polygon(fillvects)
				drawpoly.material = preload("res://maingame/materials/grass_fill.tres")
				get_node("Fairway").add_child(drawpoly)
				var collisionpoly = CollisionPolygon2D.new()
				collisionpoly.set_polygon(fillvects)
				#collisionpoly.position.y -= 25
				get_node("Fairway").add_child(collisionpoly)
				
			HazardType.TEEBOX:
				# top line
				var drawline = Line2D.new()
				drawline.z_index = 1
				drawline.use_parent_material = true
				drawline.width = 45
				drawline.begin_cap_mode = Line2D.LINE_CAP_ROUND
				drawline.end_cap_mode = Line2D.LINE_CAP_ROUND
				drawline.texture_mode = Line2D.LINE_TEXTURE_TILE
				drawline.points = currentpiece.line
				get_node("Teebox").add_child(drawline)
				
				# fill and collision polygons
				var fillvects = closepoly_to_screenbottom(currentpiece.line)
				var drawpoly = Polygon2D.new()
				drawpoly.set_polygon(fillvects)
				drawpoly.material = preload("res://maingame/materials/grass_fill.tres")
				get_node("Teebox").add_child(drawpoly)
				var collisionpoly = CollisionPolygon2D.new()
				collisionpoly.set_polygon(fillvects)
				collisionpoly.position.y -= 22.5
				get_node("Teebox").add_child(collisionpoly)
				
			HazardType.GREEN:
				# top line
				var drawline = Line2D.new()
				drawline.z_index = 1
				drawline.use_parent_material = true
				drawline.width = 25
				drawline.points = currentpiece.line
				get_node("Green").add_child(drawline)
				
				# fill and collision polygons
				var fillvects = closepoly_to_screenbottom(currentpiece.line)
				var drawpoly = Polygon2D.new()
				drawpoly.set_polygon(fillvects)
				drawpoly.material = preload("res://maingame/materials/grass_fill.tres")
				get_node("Green").add_child(drawpoly)
				var collisionpoly = CollisionPolygon2D.new()
				collisionpoly.set_polygon(fillvects)
				collisionpoly.position.y -= 12.5
				get_node("Green").add_child(collisionpoly)
				
			HazardType.WATER:
				var fillvects = closepoly_to_screenbottom(currentpiece.line)
				var drawpoly = Polygon2D.new()
				drawpoly.set_polygon(fillvects)
				drawpoly.material = preload("res://maingame/materials/water.tres")
				get_node("Water").add_child(drawpoly)
		
		# Add clutter
		for currentclutter in currentpiece.clutter:
			if currentclutter.resource == "BALL_START_POSITION":
				get_parent().get_node("Ball").position = currentclutter.position
				continue
			get_parent().get_node(currentclutter.resource).position = currentclutter.position
			get_parent().get_node(currentclutter.resource).visible = true
			if currentclutter.collides:
				get_parent().get_node(currentclutter.resource).disabled = false
				

# called to convert a line into a polygon filled to the bottom of screen
func closepoly_to_screenbottom(inputvects):
	var screenbottom = get_viewport_rect().size.y / 2
	var outputvects = inputvects.duplicate()
	
	if inputvects.size() > 0:
		var bottomrightvector = inputvects[inputvects.size() - 1]
		var bottomleftvector = inputvects[0]
		bottomrightvector.y = screenbottom
		bottomleftvector.y = screenbottom
		outputvects.append(bottomrightvector)
		outputvects.append(bottomleftvector)
	
	return outputvects
