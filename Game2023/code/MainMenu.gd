extends Control

func _on_START_pressed():
	get_tree().change_scene("res://GameScenes/First_level.tscn")

func _on_QUIT_pressed():
	get_tree().quit()

func _on_CONTROLS_pressed():
	get_tree().change_scene("res://MenuScenes/Control.tscn")
