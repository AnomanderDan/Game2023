extends RayCast

func _ready():
	add_exception(owner)

func _physics_process(delta):
	if is_colliding():
		var detected = get_collider()
		
		if detected is Chargeable:
			detected.charge(owner)
