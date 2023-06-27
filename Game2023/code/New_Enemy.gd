class_name Enemy
extends KinematicBody


onready var target_location : Node = $"../Player"
onready var agent : NavigationAgent = $NavigationAgent
onready var aggro = $Aggro


export var patrol_point = []


var speed = 100
var min_speed = 50
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
	match state:
		PATROL:
			find_player()
			var next = agent.get_next_location()
			var velocity = (next - transform.origin).normalized() * min_speed * delta
			move_and_slide(velocity)
			
			var i = 0
			agent.set_target_location(patrol_point[i])
			if agent.is_target_reached():
				agent.get_next_location()
		
		
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
