extends Area


func _ready():
	$AnimationPlayer.play("Nothing")

func _on_EventArea_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("Event")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Event":
		queue_free()
