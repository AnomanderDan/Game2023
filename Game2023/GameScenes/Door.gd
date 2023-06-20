extends StaticBody

export var open = false

var playback = null


func _ready():
	playback = $AnimationTree.get("parameters/playback")


func toggle_door(_body):
	open = !open
	
	if open:
		playback.travel("Open")
	
	else:
		playback.travel("Close")
