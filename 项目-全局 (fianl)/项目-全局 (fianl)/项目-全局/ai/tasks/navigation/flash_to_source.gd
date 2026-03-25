@tool
class_name FlashToSource
extends BTAction

var src_pos:Vector2
var enemy:Enemy

func _setup() -> void:
	enemy = agent as Enemy
	
	
func _tick(_delta: float) -> Status:
	src_pos = blackboard.get_var(BBName.source_position)
	enemy.global_position = src_pos
	
	blackboard.set_var(BBName.can_flash,false)
	return SUCCESS
