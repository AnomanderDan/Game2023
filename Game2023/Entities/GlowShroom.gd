extends Spatial

var animation = null

onready var music : AudioStreamPlayer = $AudioStreamPlayer
onready var particles = $Particles

func _ready():
	animation = $AnimationTree.get("parameters/playback")
	particles.emitting = true
	music.playing == false

func _on_Area_area_entered(area):
	if area.get_parent().has_method("recover_power"):
		print("entered")
		area.get_parent().recover_power(20)
		animation.travel("Light_Dim")
		particles.emitting = false
		$Timer.start()


func _on_Timer_timeout():
	animation.travel("Light_Up")
