extends Node2D

func _input(event):
	# Load In Game Menu
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		get_node("InGameMenu").visible = true
