extends Area


var player = null

func seen():
	return player != null

func _on_Aggro_body_entered(body):
	if body.name == "Player":
		player = body

func _on_Aggro_body_exited(_body):
	player = null
