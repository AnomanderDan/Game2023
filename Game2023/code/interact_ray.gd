extends RayCast

onready var prompt = $Prompt


func _ready():
	add_exception(owner)

func _physics_process(_delta):
	prompt.text = ""
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactive:
			prompt.text = detected.get_prompt()
			
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)
		
		elif detected is InteractionPoint:
			prompt.text = detected.get_prompt()
			
			if Input.is_action_pressed(detected.prompt_action):
				detected.charge(owner)
