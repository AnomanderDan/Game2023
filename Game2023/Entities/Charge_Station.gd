class_name Charger
extends StaticBody

onready var power = max_power setget _set_power

export var max_power = 150
export var start_pwr = 0
export var deplete = 0


signal pwr_up()
signal pwr_down()


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("OFF")

#Energy related functions:
func _set_power(value):
	var prev_power = power
	power = clamp(value, 0, max_power)
	print(power)
	if power == max_power:
		print("powered_up")
		emit_signal("pwr_up")
		if power >= 0:
			$AnimationPlayer.play("ON")
			$Timer.start()
		
	elif power == start_pwr:
		print("powered down")
		$Timer.stop()
		$AnimationPlayer.play("OFF")
		emit_signal("pwr_down")

func add_power(amount):
	_set_power(power + amount)

func lose_power(amount):
	_set_power(power - amount)

func charge(body):
	add_power(50)

func _on_Timer_timeout():
	lose_power(deplete)
	if power >= 0:
		$Timer.start()