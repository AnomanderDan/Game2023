extends KinematicBody

#gravity
var gravity = 15

#Idle rotation
var xlocation = rand_range(-360, 360)
var zlocation = rand_range(-360, 360)

export var checkpoints = [Vector3(0, 0, 0)]
var target_index = 0

#following player
var attack = false

#player escape
var player_escape = false

#face player
onready var target = get_parent().get_node("Player")
var rot_speed = 0.05

#map nav
onready var agent : NavigationAgent = $NavigationAgent
onready var target_location : Node = $"../Player"
var speed = 5
var minimum_speed = 3
var idle_speed = rand_range(minimum_speed, speed)
var move_or_not = [true, false]
var start_move = move_or_not[randi() % move_or_not.size()] 


func _on_Area_body_entered(body):
	if body.name == ("Player"):
		rot_speed = 0.1
		attack = true

func _process(delta):
	if attack == true:
		if $"../Player" != null:
			#face player
			var global_pos = self.global_transform.origin
			var target_pos = target.global_transform.origin
			var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
			var wrotation = Quat(global_transform.basis).slerp(Quat(wtransform.basis), rot_speed)
			self.global_transform = Transform(Basis(wrotation), global_pos)
			
			#set player location
			agent.set_target_location(target_location.transform.origin)
			#move to player
			var next = agent.get_next_location()
			var velocity = (next - transform.origin).normalized() * speed * delta
			move_and_collide(velocity)
	elif player_escape == false:
		#idle action
		var global_pos = self.global_transform.origin
		var wtransform = self.global_transform.looking_at(Vector3(xlocation, global_pos.y, zlocation), Vector3.UP)
		var wrotation = Quat(global_transform.basis).slerp(Quat(wtransform.basis), rot_speed)
		self.global_transform = Transform(Basis(wrotation), global_pos)
		#if start_move == true:
			#var velocity = global_transform.basis.z.normalized() * idle_speed * delta
			#move_and_collide(velocity)
	else:
		agent.set_target_location(checkpoints[target_index])
		#move to player
		var next = agent.get_next_location()
		var velocity = (next - transform.origin).normalized() * speed * delta
		move_and_collide(velocity)
		print("working")
		#enemy look at player when they escape
		#var global_pos = self.global_transform.origin
		#var target_pos = target.global_transform.origin
		#var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
		#var wrotation = Quat(global_transform.basis).slerp(Quat(wtransform.basis), rot_speed)
		#self.global_transform = Transform(Basis(wrotation), global_pos)
	
	if not is_on_floor():
		move_and_collide(-global_transform.basis.y.normalized() * gravity * delta)


func _on_Area_body_exited(body):
	if body.name == ("Player"):
		rot_speed = 0.05
		attack = false
		#enemy looks at player after escape
		player_escape = true
		$Timer2.start()


func _on_Timer_timeout():
	$Timer.set_wait_time(rand_range(4, 8))
	xlocation = rand_range(-360, 360)
	zlocation = rand_range(-360, 360)
	#random idle speed
	idle_speed = rand_range(minimum_speed, speed)
	#enemy will move or observe
	start_move = move_or_not[randi() % move_or_not.size()]
	$Timer.start()


func _on_NavigationAgent_velocity_computed(safe_velocity):
	move_and_collide(safe_velocity)




func _on_Timer2_timeout():
	#back to idle
	player_escape = false
