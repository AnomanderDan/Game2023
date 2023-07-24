class_name Interactive
extends StaticBody

signal interacted(body)

export var activity = false
export var prompt_action = "interact"
export var prompt_message = "interact"

func get_prompt():
	var key_name = ""
	for action in InputMap.get_action_list(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_scancode_string(action.scancode)
	return prompt_message + "\n[" + key_name + "]"


func interact(body):
	print("interacted")
	emit_signal("interacted", body)
