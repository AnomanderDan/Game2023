class_name Charger
extends StaticBody

onready var power = max_power setget _set_power

export var max_power = 150
export var start_pwr = 0
export var time_taken = 0

onready var timer : Timer = $Timer


signal pwr_up()
signal pwr_down()


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("OFF")
	power = start_pwr

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
			timer.start(time_taken)
		
	elif power == start_pwr:
		print("powered down")
		if power >= 0:
			timer.stop()
			$AnimationPlayer.play("OFF")
			emit_signal("pwr_down")

func add_power(amount):
	_set_power(power + amount)

func lose_power(amount):
	_set_power(power - amount)

func charge(body):
	add_power(1)

func _on_Timer_timeout():
	lose_power(max_power)
