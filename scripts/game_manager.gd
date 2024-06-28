# 2D Golf Game Manager
# ---------------------
# Game initialization and control items

extends Node

const debugmode = true

var currentlevel : Array[LevelGenerator.levelsection]
var currentcourse : Array[LevelGenerator.coursehole]

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	currentcourse = LevelGenerator.generate_course(1)	
	currentlevel = LevelGenerator.generate_level(Vector2(-1280,400), currentcourse[0].sections)

	launch_level()

func launch_level():
	var maingame = preload("res://MainGame/main_game.tscn").instantiate()
	get_tree().get_root().get_node("Golf2D").add_child(maingame)
