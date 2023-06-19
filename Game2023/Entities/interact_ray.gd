extends RayCast


func _ready():
	add_exception(owner)

func _physics_process(delta):
	if is_colliding():
		print("work for once")
