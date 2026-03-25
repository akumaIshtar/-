@tool
extends BTAction

var boss :Boss
var timer:float = 0.0
const GENERATE_TIME = 2.0

var hurt_freq:int = 10.0
var time_to_enable:int=0.0

func _setup() -> void:
	boss = agent as Boss
	

func _tick(_delta: float) -> Status:
	
	if timer<GENERATE_TIME:
		if timer<GENERATE_TIME-0.5:
			boss.laser_search()
			boss.boss_laser.disable_collision()
		timer+=_delta
		return RUNNING
	
	var laser_is_finished = boss.laser_develop()
	
	if(time_to_enable%hurt_freq==0)&& boss.boss_laser!=null:
		boss.boss_laser.disable_collision()
	elif boss.boss_laser!=null:
		boss.boss_laser.enable_collision()
	
	time_to_enable+=1
	
	SignalBus.camera_shake_requested.emit(0.1,0.5)
	if laser_is_finished:
		return RUNNING
	else:
		timer = 0.0
		return SUCCESS
	
