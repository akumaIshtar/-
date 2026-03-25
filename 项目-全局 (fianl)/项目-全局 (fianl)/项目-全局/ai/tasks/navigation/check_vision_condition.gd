# check_vision.gd
class_name CheckVisionCondition
extends BTCondition

var vision: VisionDetector
var enemy:Enemy

func _setup():
	enemy = agent as Enemy
	vision = enemy.find_child("VisionDetector") as VisionDetector
	

func _tick(delta: float) -> Status:
	var target :Player = vision.get_target()
	if target:
		if abs(target.global_position.y-enemy.global_position.y)<30:
			
			return SUCCESS
	else:
		
		return FAILURE
	return FAILURE
