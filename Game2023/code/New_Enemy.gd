class_name Enemy
extends KinematicBody


onready var target_location : Node = $"../Player"
onready var agent : NavigationAgent = $NavigationAgent
onready var aggro = $Aggro


export var patrol_point = []
<<<<<<< Updated upstream
var current_point = 0

var speed = 200
var min_speed = 100
=======
var target_index = 0

var speed = 100
var min_speed = 50
>>>>>>> Stashed changes
var state = null
var rot_speed = 0.05

enum{
	PATROL
	ATTACK
	DIE
}

func pick_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _ready():
	state = pick_state([PATROL])

func _physics_process(delta):
	print(state)
	match state:
		PATROL:
			find_player()
			agent.set_target_location(patrol_point[current_point])
			var next = agent.get_next_location()
			var velocity = (next - transform.origin).normalized() * min_speed * delta
			move_and_slide(velocity)
			var dir = (next - transform.origin).normalized()
			dir.y = 0
			look_at(transform.origin + dir, Vector3.UP)
			
			
<<<<<<< Updated upstream
			if agent.is_target_reached():
				current_point += 1
				if current_point >= len(patrol_point):
					current_point -= len(patrol_point)
				agent.set_target_location(patrol_point[current_point])
=======

			agent.set_target_location(patrol_point[target_index])
#			if agent.is_target_reached():
#				state = pick_state([PATROL])
#				patrol_point[target_index] + 1
			
>>>>>>> Stashed changes
		
		
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

		
		
		DIE:
			queue_free()



func find_player():
	if aggro.seen():
		state = ATTACK


func _on_NavigationAgent_velocity_computed(safe_velocity):
	move_and_collide(safe_velocity)
