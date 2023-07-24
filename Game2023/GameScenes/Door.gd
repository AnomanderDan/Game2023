extends StaticBody

export var open = false

var playback = null


func _ready():
	playback = $AnimationTree.get("parameters/playback")


func toggle_door(_body):
	open = !open
	
	if open == true:
		playback.travel("Open")
	
	else:
		playback.travel("Close")


func _on_Charge_Station_pwr_up():
	playback.travel("Open")


func _on_Charge_Station_pwr_down():
	playback.travel("Close")
