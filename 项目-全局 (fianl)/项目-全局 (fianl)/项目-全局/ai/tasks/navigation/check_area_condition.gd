class_name CheckAreaCondition
extends BTCondition

var area:VisionArea
var enemy:Enemy

func _setup() -> void:
	enemy = agent as Enemy
	area = enemy.find_child("VisionArea") as VisionArea
	
	
func _tick(_delta: float) -> Status:
	var target:Player = area.get_target()
	if target:
		
		return SUCCESS
	else:
		
		return FAILURE
	
