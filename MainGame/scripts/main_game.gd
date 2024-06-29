extends Node2D

var HazardType = LevelGenerator.HazardType

func _ready():
	# Configure camera bounds
	get_node("Camera2D").limit_left = 0
	get_node("Camera2D").limit_right = GameManager.currentlevel.width
	
	draw_level()

func _input(event):
	# Load In Game Menu
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		get_node("InGameMenu").visible = true
		
func _process(delta):
	# Move camera to follow ball
	get_node("Camera2D").position.x = get_node("Ball").position.x

func draw_level():
	# Draw polygons
	for currentpiece in GameManager.currentlevel.sections:

		match currentpiece.type:
			
			HazardType.FAIRWAY:
				# top line
				var drawline = Line2D.new()
				drawline.z_index = 1
				drawline.use_parent_material = true
				drawline.width = 25
				drawline.begin_cap_mode = Line2D.LINE_CAP_ROUND
				drawline.end_cap_mode = Line2D.LINE_CAP_ROUND
				drawline.texture_mode = Line2D.LINE_TEXTURE_TILE
				drawline.points = currentpiece.line
				get_node("Ground/Fairway").add_child(drawline)
				
				# fill and collision polygons
				var fillvects = closepoly_to_screenbottom(currentpiece.line)
				var drawpoly = Polygon2D.new()
				drawpoly.set_polygon(fillvects)
				drawpoly.material = preload("res://maingame/materials/grass_fill.tres")
				get_node("Ground/Fairway").add_child(drawpoly)
				var collisionpoly = CollisionPolygon2D.new()
				collisionpoly.set_polygon(fillvects)
				#collisionpoly.position.y -= 25
				get_node("Ground/Fairway").add_child(collisionpoly)
				
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
				get_node("Ground/Teebox").add_child(drawline)
				
				# fill and collision polygons
				var fillvects = closepoly_to_screenbottom(currentpiece.line)
				var drawpoly = Polygon2D.new()
				drawpoly.set_polygon(fillvects)
				drawpoly.material = preload("res://maingame/materials/grass_fill.tres")
				get_node("Ground/Teebox").add_child(drawpoly)
				var collisionpoly = CollisionPolygon2D.new()
				collisionpoly.set_polygon(fillvects)
				collisionpoly.position.y -= 22.5
				get_node("Ground/Teebox").add_child(collisionpoly)
				
			HazardType.GREEN:
				# top line
				var drawline = Line2D.new()
				drawline.z_index = 1
				drawline.use_parent_material = true
				drawline.width = 25
				drawline.points = currentpiece.line
				get_node("Ground/Green").add_child(drawline)
				
				# fill and collision polygons
				var fillvects = closepoly_to_screenbottom(currentpiece.line)
				var drawpoly = Polygon2D.new()
				drawpoly.set_polygon(fillvects)
				drawpoly.material = preload("res://maingame/materials/grass_fill.tres")
				get_node("Ground/Green").add_child(drawpoly)
				var collisionpoly = CollisionPolygon2D.new()
				collisionpoly.set_polygon(fillvects)
				collisionpoly.position.y -= 12.5
				get_node("Ground/Green").add_child(collisionpoly)
				
			HazardType.WATER:
				var fillvects = closepoly_to_screenbottom(currentpiece.line)
				var drawpoly = Polygon2D.new()
				drawpoly.set_polygon(fillvects)
				drawpoly.material = preload("res://maingame/materials/water.tres")
				get_node("Ground/Water").add_child(drawpoly)
	
	# Draw clutter
	for currentclutter in GameManager.currentlevel.clutter:
		get_node(currentclutter.resource).position = currentclutter.position
		get_node(currentclutter.resource).visible = true
		if currentclutter.collides:
			get_node(currentclutter.resource).disabled = false


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
