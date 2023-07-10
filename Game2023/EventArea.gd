extends Area


func _on_EventArea_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("Event")
