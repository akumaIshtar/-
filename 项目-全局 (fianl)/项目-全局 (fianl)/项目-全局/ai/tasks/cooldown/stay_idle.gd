@tool
extends BTAction

var stay_timer:float=0.0


func _tick(delta: float) -> Status:
	if stay_timer<1.0:
		stay_timer+=delta
		return RUNNING
	else:
		stay_timer = 0.0
		
		return SUCCESS
