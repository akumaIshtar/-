@tool
class_name LaserAttack
extends BTAction

var wizard :Wizard
var visionArea:VisionArea
var hurt_freq:int = 2.0
var time_to_enable:int=0.0

func _setup() -> void:
	wizard = agent as Wizard
	visionArea = wizard.find_child("VisionArea") as VisionArea

func _tick(_delta: float) -> Status:
	if visionArea.get_target():
		wizard.soulorb_move(visionArea.get_target().global_position)
		
	var laser_is_finished = wizard.laser_develop()
	
	if(time_to_enable%hurt_freq==0)&& wizard.laser!=null:
		wizard.laser.disable_collision()
	elif wizard.laser!=null:
		wizard.laser.enable_collision()
	
	time_to_enable+=1
	
	SignalBus.camera_shake_requested.emit(0.1,0.5)
	if laser_is_finished:
		return RUNNING
	else:
		wizard.release_soulorb()
		return SUCCESS
	
