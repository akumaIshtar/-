@tool
class_name FlashToPlayer
extends BTAction

var enemy:Enemy
var area:VisionArea
var target:Player
var flash_position:Vector2
var target_position:Vector2
var offset:float = 40

func _setup() -> void:
	enemy = agent as Enemy
	area = enemy.find_child("VisionArea") as VisionArea
	
	
	#记录原位置
	blackboard.set_var(BBName.source_position,enemy.global_position)
	
	
func _tick(_delta: float) -> Status:
	target = area.get_target() as Player
	
	
	if not target && not is_instance_valid(target):
		return FAILURE
	
	if not target.is_on_floor():
		return FAILURE
	
	var raw_position = _calculate_falsh_position()
	
	
	
	enemy.global_position = raw_position
	
	blackboard.set_var(BBName.can_flash,true)#判断是否需要闪回原位
	blackboard.set_var(BBName.direction_var,Vector2(target.direction,0))
	blackboard.set_var(BBName.can_attack,true)
	
	
	return SUCCESS


func _calculate_falsh_position()->Vector2:
	var player_forward = Vector2(target.direction,0)
	#var player_forward = Vector2.RIGHT.rotated(target.rotation) if target.rotation_degrees == 0 else Vector2(target.direction,0)
	
	return target.global_position - player_forward.normalized()*offset
