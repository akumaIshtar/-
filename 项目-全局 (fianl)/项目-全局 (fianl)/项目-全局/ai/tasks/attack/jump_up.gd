@tool
class_name JumpUp
extends BTAction

var boss:Boss
var timer:float = 0.0

const jump_speed:float = -200
const jumptimer:float = 0.25

func _setup() -> void:
	boss = agent as Boss

func _tick(delta: float) -> Status:
	var direction = blackboard.get_var(BBName.direction_var)
	boss.velocity.y = jump_speed
	#animationPlayer.play("attack2")
	
	timer+=delta
	
	if timer>jumptimer:
		timer = 0.0
		return SUCCESS
	return RUNNING
