extends CanvasLayer

func _ready():
	# connect buttons to actions
	get_node("ResumeButton").pressed.connect(self._resume_pressed.bind())
	get_node("ExitButton").pressed.connect(self._exit_pressed.bind())

func _resume_pressed():
	hide()
	get_tree().paused = false
	
func _exit_pressed():
	get_tree().quit()
