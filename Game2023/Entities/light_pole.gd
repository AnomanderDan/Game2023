extends Spatial

export var on = false

var playback = null


func _ready():
	playback = $AnimationTree.get("parameters/playback")


func toggle_light(_body):
	on = !on
	
	if on == true:
		playback.travel("Light_Up")
	
	else:
		playback.travel("Dim")
