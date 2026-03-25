# chase_action.gd
@tool
class_name ChasePlayer
extends BTAction


@export var horizontal_stop_range: float = 10.0  # 水平停止范围


var enemy:Enemy
var vision:VisionDetector

func _setup():
	enemy = agent as Enemy
	vision = enemy.find_child("VisionDetector")
	enemy.edge_ray.target_position = Vector2(0,30)
	

func _tick(delta: float) -> Status:
	var target = vision.get_target()
	if not target or not is_instance_valid(target):
		return FAILURE
	
	if !enemy.edge_ray.is_colliding():
		return FAILURE
	
	# 将目标位置限制在同一水平线
	var fixed_target_pos = Vector2(target.global_position.x, agent.global_position.y)
	enemy.navigation.target_position = fixed_target_pos
	
	# 获取水平移动方向
	var next_pos = enemy.navigation.get_next_path_position()
	next_pos.y = agent.global_position.y  # 强制水平路径
	var direction = Vector2(next_pos.x - agent.global_position.x, 0).normalized()
	
	# 水平距离判断
	if abs(agent.global_position.x - fixed_target_pos.x) <= horizontal_stop_range:
		agent.velocity = Vector2.ZERO
		return SUCCESS
	
	# 仅水平移动
	agent.velocity = direction*enemy.data.run_speed
	agent.move_and_slide()
	
	return RUNNING
