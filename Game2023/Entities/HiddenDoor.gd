class_name InteractionPoint
extends StaticBody


onready var power = max_power setget _set_power

export var prompt_action = "interact"
export var prompt_message = "interact"
export var max_power = 100
export var start_pwr = 0

onready var animation = $AnimationPlayer


func _ready():
	power = 0
	animation.play("close")

func get_prompt():
	var key_name = ""
	for action in InputMap.get_action_list(prompt_action):
		if action is InputEventMouseButton:
			key_name = "Right-Click"
	return prompt_message + "\n[" + key_name + "]"

func _set_power(value):
	var prev_power = power
	power = clamp(value, 0, max_power)
	if power == max_power:
		queue_free()

func add_power(amount):
	_set_power(power + amount)

func charge(_body):
	add_power(1)
