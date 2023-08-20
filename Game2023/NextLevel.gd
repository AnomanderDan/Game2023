extends Area

export var scene = ""


func _on_NextLevel_body_entered(body):
	if body.name == "Player":
		var _return_value = get_tree().change_scene("res://GameScenes/"+ scene +".tscn")
