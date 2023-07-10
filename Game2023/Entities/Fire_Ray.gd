extends RayCast

signal add_energy()

func _ready():
	add_exception(owner)

func _physics_process(delta):
	pass
