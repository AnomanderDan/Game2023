extends KinematicBody

onready var agent : NavigationAgent = $NavigationAgent

var speed = 5.0

enum{
	PATROL
	ATTACK
	DIE
}
