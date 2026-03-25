@tool
extends BTCondition

var is_first_enter:bool = true

func _tick(_delta: float) -> Status:
	if is_first_enter ==true:
		is_first_enter = false
		return SUCCESS
	return FAILURE
