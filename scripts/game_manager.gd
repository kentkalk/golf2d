# 2D Golf Game Manager
# ---------------------
# Game initialization and control items

extends Node

const debugmode = true

var currentlevel : LevelGenerator.level

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	currentlevel = LevelGenerator.level.new()
	currentlevel.generate()
	
	# launch level
	var maingame = preload("res://maingame/main_game.tscn").instantiate()
	get_tree().get_root().get_node("Golf2D").add_child(maingame)
