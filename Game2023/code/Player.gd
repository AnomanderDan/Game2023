extends KinematicBody

export var speed = 40
export var concentrate_spd = 25
export var friction = 0.875
export var gravity = 80.0
export var max_power = 100

var move_direction = Vector3()
var vel = Vector3()
var cam_rotation_spd = 50
var animate = null

onready var camera = $CameraRig/Camera
onready var camera_rig = $CameraRig
onready var cursor = $Cursor
onready var power = max_power setget _set_power
onready var timer = $Timer
onready var player_animation = $player1/PlayerAnimations

signal Power_changed(power)


func _ready():
	camera_rig.set_as_toplevel(true)
	animate = $AnimationTree.get("parameters/playback")


func _physics_process(delta):
	camera_follows_player()
	rotate_camera(delta)
	
	look_at_cursor()
	run(delta)
	concentrate()
	
	vel *= friction
	var grav_res = get_floor_normal() if is_on_floor() else Vector3.UP
	vel -= grav_res * gravity * delta
	#vel.y -= gravity * delta
	vel = move_and_slide_with_snap(vel, Vector3.UP, Vector3.UP, true, 3)

#Camera Functionality
func camera_follows_player():
	var player_pos = global_transform.origin
	camera_rig.global_transform.origin = player_pos


func rotate_camera(delta):
	if Input.is_action_pressed("rotate_right"):
		camera_rig.rotate_y(deg2rad(-cam_rotation_spd * delta))
	if Input.is_action_pressed("rotate_left"):
		camera_rig.rotate_y(deg2rad(cam_rotation_spd * delta))


#Cursor tageting
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


#Movement
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
	if Input.is_action_pressed("light_beam"):
		vel += move_direction * concentrate_spd * delta
	else:
		vel += move_direction * speed * delta
	if move_direction.length() >= 0.1:
		player_animation.play("Armature001Action001 2")
	else:
		player_animation.play("Armature001Action001")

#Lamp mode change
func concentrate():
	if Input.is_action_pressed("light_beam"):
		animate.travel("Concentrated_Light")
		
	else:
		animate.travel("Normal_Light")


#energy related functions
func recover_power(amount):
	_set_power(power + amount)

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
	if Input.is_action_pressed("light_beam"):
		power_loss(6)
		timer.start()
	else:
		power_loss(3)
		timer.start()


#Kill Zone Code
func die():
	get_tree().reload_current_scene()


func _on_Detection_area_entered(area):
	if area.name == "Death":
		die()


func _on_DeathTimer_timeout():
	die()
