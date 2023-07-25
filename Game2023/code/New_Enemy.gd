class_name Chargeable
extends KinematicBody


onready var target_location : Node = $"../Player"
onready var agent : NavigationAgent = $NavigationAgent
onready var aggro = $Aggro
onready var power = max_power setget _set_power

export var patrol_point = []
export var max_power = 150
export var start_pwr = 0
export var time_taken = 0

var current_point = 0
var speed = 220
var min_speed = 100
var state = null
var rot_speed = 0.05

enum{
	PATROL
	ATTACK
	STUN
	DIE
}

#Movement and states
func pick_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _ready():
	state = pick_state([PATROL])
	power = start_pwr

func _physics_process(delta):
	match state:
		#Patrol state: moves towards a set of points
		PATROL:
			find_player()
			agent.set_target_location(patrol_point[current_point])
			var next = agent.get_next_location()
			var velocity = (next - transform.origin).normalized() * min_speed * delta
			move_and_slide(velocity)
			var dir = (next - transform.origin).normalized()
			dir.y = 0
			look_at(transform.origin + dir, Vector3.UP)
				
				
			if agent.is_target_reached():
				current_point += 1
				if current_point >= len(patrol_point):
					current_point -= len(patrol_point)
					agent.set_target_location(patrol_point[current_point])
		
		
		#Attack state: Chases the player when found
		ATTACK:
			var player = aggro.player
			if player != null:
				var next = agent.get_next_location()
				var velocity = (next - transform.origin).normalized() * speed * delta
				move_and_slide(velocity)
				
				
				var global_pos = self.global_transform.origin
				var target_pos = player.global_transform.origin
				var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
				var wrotation = Quat(global_transform.basis).slerp(Quat(wtransform.basis), rot_speed)
				self.global_transform = Transform(Basis(wrotation), global_pos)
				agent.set_target_location(target_location.transform.origin)
			
			elif player == null:
				state = pick_state([PATROL])
		
		
		#Stun state: immobilization for a few seconds
		STUN:
			speed = 0
			min_speed = 0

		
		#Die state: enemy termination
		DIE:
			queue_free()


#Player search
func find_player():
	if aggro.seen():
		state = ATTACK

#safe_velocity
func _on_NavigationAgent_velocity_computed(safe_velocity):
	move_and_collide(safe_velocity)


#Energy related functions:
func _set_power(value):
	var prev_power = power
	power = clamp(value, 0, max_power)
	if power == max_power:
		state = STUN
		$Timer.start(time_taken)
		
	elif power == 0:
		speed = 200
		min_speed = 100
		if aggro.player != null:
			state = ATTACK
		elif aggro.player == null:
			state = PATROL

func add_power(amount):
	_set_power(power + amount)

func lose_power(amount):
	_set_power(power - amount)

func charge(_body):
	add_power(1)

func _on_Timer_timeout():
	lose_power(max_power)

