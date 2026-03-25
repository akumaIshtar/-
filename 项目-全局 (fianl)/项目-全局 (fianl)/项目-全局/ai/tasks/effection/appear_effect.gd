@tool
class_name AppearEffect
extends BTAction

var enemy:Enemy

func _setup() -> void:
	enemy = agent as Enemy
	
func _tick(_delta: float) -> Status:
	if enemy.has_method("appear_tween"):
		enemy.appear_tween()
	if enemy.has_method("play_puperfog_particle"):
		enemy.play_puperfog_particle()
	return SUCCESS
