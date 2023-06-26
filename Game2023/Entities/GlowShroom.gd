extends Spatial

var animation = null

func _ready():
	animation = $AnimationTree.get("parameters/playback")

func _on_Area_area_entered(area):
	if area.get_parent().has_method("recover_power"):
		print("entered")
		area.get_parent().recover_power(20)


func _on_Timer_timeout():
	animation.travel("Light_Up")


func _on_Area_area_exited(body):
	animation.travel("Light_Dim")
	$Timer.start()
