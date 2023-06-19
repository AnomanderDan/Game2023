extends KinematicBody

onready var agent : NavigationAgent = $NavigationAgent

export var checkpoints = [""]

export var target_index = ""
var speed = 5.0

enum{
	PATROL
	ATTACK
	DIE
}

func _ready():
	agent.set_target_location(checkpoints.transform.origin )


func _physics_process(delta):
	var next = agent.get_next_location()
	
	var velocity = (next - transform.origin).normalized() * speed * delta
	
	move_and_collide(velocity)
