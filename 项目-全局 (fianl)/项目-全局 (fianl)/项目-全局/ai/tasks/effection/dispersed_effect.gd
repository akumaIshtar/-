@tool
class_name DispersedEffect
extends BTAction

var enemy:Enemy

func _setup() -> void:
	enemy = agent as Enemy
	
func _tick(_delta: float) -> Status:
	if enemy.has_method("dispersed_tween"):
		enemy.dispersed_tween()
	
	return SUCCESS
