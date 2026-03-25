@tool
extends BTCondition

var boss:Boss
var range:float = 320

func _setup() -> void:
	boss = agent as Boss
	
func _tick(delta: float) -> Status:
	if boss.target!=null:
		if abs(boss.target.global_position.y-boss.global_position.y)>=0:
			var distance = boss.target.global_position.x-boss.global_position.x
			var direction = blackboard.get_var(BBName.direction_var)
			if abs(distance)>=range:
				if distance>0&&direction.x>0||distance<0&&direction.x<0:
					return SUCCESS
	else:
		return FAILURE
	return FAILURE
