@tool
class_name Dispersed
extends BTAction

var enemy:PhantomStriker

func _setup() -> void:
	enemy = agent as PhantomStriker

func _tick(_delta: float) -> Status:
	enemy.dispersed_from_world()
	return SUCCESS
