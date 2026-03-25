@tool
extends BTAction

var enemy:Enemy



func _setup() -> void:
	enemy = agent as Enemy


func _tick(_delta: float) -> Status:
	enemy.attack_alert(enemy.global_position)
	return SUCCESS
