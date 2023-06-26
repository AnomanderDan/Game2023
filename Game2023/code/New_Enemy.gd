extends KinematicBody

onready var agent : NavigationAgent = $NavigationAgent
onready var target = get_parent().get_node("Player")
onready var target_location : Node = $".../Player"

var state = PATROL

var speed = 5
var idle_speed = 3

enum{
	PATROL
	ATTACK
	DIE
}

func _ready():
	state = pick_state([PATROL])


func pick_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _physics_process(delta):
	
	match state:
		
		PATROL:
			pass
		
		
		ATTACK:
			pass
		
		
		DIE:
			pass
