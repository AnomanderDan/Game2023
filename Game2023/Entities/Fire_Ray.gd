extends RayCast

func _ready():
	add_exception(owner)

func _physics_process(_delta):
	if is_colliding():
		var detected = get_collider()
		
		if detected is Charger:
			detected.charge(owner)
		
		elif detected is Chargeable:
			detected.charge(owner)
