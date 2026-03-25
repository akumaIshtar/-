@tool
class_name VisionFollow
extends BTAction

var boss:Boss
var direction:Vector2

func _setup() -> void:
	boss = agent as Boss
	
func _tick(delta: float) -> Status:
	if boss.target!=null:
		direction = Vector2(boss.target.global_position - boss.global_position).normalized()
		blackboard.set_var(BBName.direction_var,direction)
		
	return SUCCESS
