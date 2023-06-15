extends Control

var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused
		print("paused")

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_CONTINUE_pressed():
	self.is_paused = false
	print("continue")

func _on_QUIT_pressed():
	get_tree().quit()
