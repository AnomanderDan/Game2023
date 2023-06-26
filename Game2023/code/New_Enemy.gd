extends KinematicBody


onready var target_location : Node = $"../Player"
onready var agent : NavigationAgent = $NavigationAgent
onready var aggro = $Aggro


export var patrol_point = []


var speed = 45
var state = null

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
			pass
			find_player()
			agent.set_target_location(patrol_point)
			
			var next = agent.get_next_location()
			var velocity = (next - transform.origin).normalized() * speed * delta
			move_and_slide(velocity)
		
		
		ATTACK:
			var player = aggro.player
			if player != null:
				
				agent.set_target_location(target_location.transform.origin)
				
				var next = agent.get_next_location()
				var velocity = (next - transform.origin).normalized() * speed * delta
				move_and_slide(velocity)
		
		
		DIE:
			queue_free()


func find_player():
	if aggro.seen():
		state = ATTACK
