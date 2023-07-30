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


func _on_Charge_Station_pwr_up():
	playback.travel("Open")


func _on_Charge_Station_pwr_down():
	playback.travel("Close")
