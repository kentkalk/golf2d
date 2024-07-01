extends Node2D

var HazardType = LevelGenerator.HazardType
var level_canvas : CanvasGroup
var clutter_container : Node2D

@export_group("Course Parameters")
@export var fairway_element : PackedScene
@export var teebox_element : PackedScene
@export var green_element : PackedScene
@export var water_element : PackedScene


func _ready():
	level_canvas = CanvasGroup.new()
	clutter_container = Node2D.new()
	add_child(level_canvas)
	add_child(clutter_container)
	
	draw_level(GameManager.currentlevel.sections)
	add_clutter(GameManager.currentlevel.clutter)


# Called to draw the actual lines and polygons of the level
func draw_level(in_level_sections):
	# Draw polygons
	for currentpiece in in_level_sections:
		var drawline
		match currentpiece.type:
			HazardType.FAIRWAY:
				drawline = fairway_element.instantiate()
			HazardType.TEEBOX:
				drawline = teebox_element.instantiate()
			HazardType.GREEN:
				drawline = green_element.instantiate()
			HazardType.WATER:
				drawline = water_element.instantiate()
				
		drawline.set_points(currentpiece.line)
		level_canvas.add_child(drawline)


func add_clutter(in_level_clutter):
	for currentclutter in in_level_clutter:
		var clutter = load("res://maingame/clutter/" + currentclutter.resource).instantiate()
		clutter.set_position(currentclutter.position)
		clutter_container.add_child(clutter)
