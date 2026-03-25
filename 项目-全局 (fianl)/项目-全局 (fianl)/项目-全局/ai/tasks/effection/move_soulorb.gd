@tool
extends BTAction

var wizard:Wizard
var visionArea:VisionArea

var move_timer:float =0.0
const MAX_MOVE_TIME = 2.0

func _setup() -> void:
	wizard = agent as Wizard
	visionArea = wizard.find_child("VisionArea") as VisionArea
	


func _tick(delta: float) -> Status:

	if visionArea.get_target():
		wizard.soulorb_move(visionArea.get_target().global_position)
		
	move_timer +=delta
	
	if move_timer>=MAX_MOVE_TIME:
		return SUCCESS
	return RUNNING

func _exit() -> void:
	move_timer = 0.0
	
