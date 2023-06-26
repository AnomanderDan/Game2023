extends Spatial

onready var animation = $AnimationPlayer

func _ready():
	animation.play("Start_Light")

func _on_Area_body_entered(body):
	if body.get_parent().has_method("recover_power"):
		body.get_parent().recover_power(5)
		animation.play("Light_Dim")
		$Timer.start()
		print("entered")


func _on_Timer_timeout():
	animation.play("Light_Up")
