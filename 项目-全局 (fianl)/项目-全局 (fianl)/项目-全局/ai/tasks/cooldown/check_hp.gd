@tool
extends BTCondition

var can_update:bool = true

func _tick(delta: float) -> Status:
	var hp = blackboard.get_var(BBName.hp_var)
	if hp<=100&&hp>0&&can_update:
		can_update = false
		return SUCCESS
	return FAILURE
