extends Spatial

export var on = false

onready var particles = $Particles

var playback = null


func _ready():
	playback = $AnimationTree.get("parameters/playback")


func toggle_light(_body):
	on = !on
	
	if on == true:
		playback.travel("Light_Up")
		particles.emitting = true
	
	else:
		playback.travel("Dim")
		particles.emitting = false


func _on_Charge_Station_pwr_up():
	playback.travel("Open")


func _on_Charge_Station_pwr_down():
	playback.travel("Close")
