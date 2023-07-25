class_name Interactive
extends StaticBody

signal interacted(body)

export var prompt_action = "interact"
export var prompt_message = "interact"

func get_prompt():
	var key_name = ""
	for action in InputMap.get_action_list(prompt_action):
		if action is InputEventMouseButton:
			key_name = "Right-Click"
	return prompt_message + "\n[" + key_name + "]"


func interact(body):
	print("interacted")
	emit_signal("interacted", body)
