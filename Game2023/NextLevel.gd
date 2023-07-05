extends Area

export var scene = ""

func _on_Area2D_area_entered(area):
	var _return_value = get_tree().change_scene("res://scenes/"+ scene +".tscn")

