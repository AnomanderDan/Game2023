class_name Interactible
extends StaticBody

export var prompt_action = "interact"

func get_prompt():
	var key_name = ""
	for action in InputMap.get_action_list(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_scancode_string(action.scancode)


func interact(area):
	print(area.name, "interacted")
