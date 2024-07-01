# 2D Golf Game Manager
# ---------------------
# Game initialization and control items

extends Node

const debug_mode = true

const ball_radius : float = 10.0
var current_level : LevelGenerator.level

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	current_level = LevelGenerator.level.new()
	current_level.generate(randi_range(3,5))
	print(current_level._par)
	
	# launch level
	var maingame = preload("res://maingame/main_game.tscn").instantiate()
	get_tree().get_root().get_node("Golf2D").add_child(maingame)
