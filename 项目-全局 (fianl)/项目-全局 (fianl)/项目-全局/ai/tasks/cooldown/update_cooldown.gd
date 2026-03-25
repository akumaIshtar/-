@tool
extends BTAction

func _enter() -> void:
	blackboard.set_var(BBName.cooldown_duration,0.2)

func _tick(_delta: float) -> Status:
	return SUCCESS
