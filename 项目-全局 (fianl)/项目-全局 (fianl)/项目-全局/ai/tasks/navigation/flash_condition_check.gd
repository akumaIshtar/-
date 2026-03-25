class_name FlashConditionCheck
extends BTCondition

var enemy:Enemy

func _setup() -> void:
	enemy = agent as Enemy
	
func _tick(_delta: float) -> Status:
	var src_pos = blackboard.get_var(BBName.source_position)
	var can_flash:bool = blackboard.get_var(BBName.can_flash)
	if src_pos != enemy.global_position && src_pos != Vector2(0.0,0.0) && can_flash:
		return SUCCESS
	else:
		return FAILURE
