extends Control

func _on_START_pressed():
	get_tree().change_scene("res://scenes/New_Test_Scene.tscn")

func _on_QUIT_pressed():
	get_tree().quit()

func _on_CONTROLS_pressed():
	get_tree().change_scene("res://extra/Rules.tscn")
