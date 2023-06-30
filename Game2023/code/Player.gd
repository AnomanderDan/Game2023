extends KinematicBody

export var speed = 50
export var friction = 0.875
export var gravity = 80.0
export var max_power = 100

var move_direction = Vector3()
var vel = Vector3()

onready var camera = $CameraRig/Camera
onready var camera_rig = $CameraRig
onready var cursor = $Cursor
onready var power = max_power setget _set_power
onready var timer = $Timer

signal Power_changed(power)


func _ready():
	camera_rig.set_as_toplevel(true)


func _physics_process(delta):
	camera_follows_player()
	
	look_at_cursor()
	run(delta)
	
	vel *= friction
	vel.y -= gravity * delta
	vel = move_and_slide_with_snap(vel, Vector3.UP, Vector3.UP, true, 3)

func camera_follows_player():
	var player_pos = global_transform.origin
	camera_rig.global_transform.origin = player_pos


func look_at_cursor():
	var player_pos = global_transform.origin
	var dropPlane = Plane(Vector3(0, 1, 0), player_pos.y)
	
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = dropPlane.intersects_ray(from, to)
	
	cursor.global_transform.origin = cursor_pos + Vector3(0, 1, 0)
	
	look_at(cursor_pos, Vector3.UP)


func run(delta):
	move_direction = Vector3()
	var camera_basis = camera.get_global_transform().basis
	if Input.is_action_pressed("up"):
		move_direction -= camera_basis.z
	elif Input.is_action_pressed("down"):
		move_direction += camera_basis.z
	if Input.is_action_pressed("left"):
		move_direction -= camera_basis.x
	elif Input.is_action_pressed("right"):
		move_direction += camera_basis.x
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	vel += move_direction * speed * delta


func recover_power(amount):
	_set_power(power + amount)

func die():
	get_tree().reload_current_scene()

func _set_power(value):
	var prev_power = power
	power = clamp(value, 0, max_power)
	if power != prev_power:
		emit_signal("Power_changed", power)
		if power == 0:
			$DeathTimer.start()
			$AnimationPlayer.play("Battery_dead")

func power_loss(amount):
	_set_power(power - amount)


func _on_Timer_timeout():
	power_loss(3)
	timer.start()


func _on_DeathTimer_timeout():
	die()
	emit_signal("killed")


func _on_Detection_area_entered(area):
	if area.name == "Death":
		die()
