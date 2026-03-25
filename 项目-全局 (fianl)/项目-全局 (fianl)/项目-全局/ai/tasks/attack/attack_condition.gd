class_name AttackCondition
extends BTCondition

var enemy:Enemy
var detectionZone:DetectionZone

func _setup() -> void:
	enemy = agent as Enemy
	detectionZone = enemy.find_child("DetectionZone") as DetectionZone
	
	
func _tick(_delta: float) -> Status:
	var target:Player = detectionZone.get_target()
	if target:
		return SUCCESS
	return FAILURE
	
