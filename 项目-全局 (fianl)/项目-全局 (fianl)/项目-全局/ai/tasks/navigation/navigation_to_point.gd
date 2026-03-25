@tool
extends BTAction
class_name NavigationToPoint

# 配置参数
@export var patrol_range: float = 200.0
@export var ray_length: float = 10.0
@export var edge_check_offset: float = 15.0

# 节点引用
var enemy: Enemy
#var front_ray: RayCast2D
#var edge_ray: RayCast2D
var patrol_points: Array[Vector2] = []
var current_direction: int = 1  # 1:右/-1:左

func _setup() -> void:
	
	enemy = agent as Enemy
	
	_init_patrol_points()
	_setup_raycasts()
	


func _init_patrol_points() -> void:
	var start_pos = enemy.global_position
	patrol_points = [
		start_pos + Vector2.RIGHT * patrol_range,
		start_pos + Vector2.LEFT * patrol_range
	]

func _setup_raycasts() -> void:
	
	var direction = blackboard.get_var(BBName.direction_var)
	# 前方障碍检测射线
	
	enemy.front_ray.target_position = Vector2(ray_length*direction.x, 0)
	enemy.front_ray.collision_mask = 0x1
	
	# 脚下悬崖检测射线
	enemy.edge_ray.target_position = Vector2(ray_length/2*direction.x, edge_check_offset)
	enemy.edge_ray.collision_mask = 0x1
	

func _update_raycasts(direction:float):
	
	enemy.front_ray.target_position = Vector2(ray_length*direction,0)
	enemy.edge_ray.target_position = Vector2(ray_length/2*direction, edge_check_offset)

func _tick(delta: float) -> Status:
	if _detect_obstacle() or _detect_cliff():
		_handle_obstacle()
	if _reached_target():
		_switch_direction()
		return SUCCESS
	
	var target_pos = patrol_points[0 if current_direction == 1 else 1]
	var move_dir = (target_pos - enemy.global_position).normalized()
	
	_update_raycasts(move_dir.x)
	blackboard.set_var(BBName.direction_var,move_dir)
	
	enemy.velocity.x = move_dir.x * enemy.data.walk_speed
	
	enemy.move_and_slide()
	
	return RUNNING

# 障碍检测逻辑
func _detect_obstacle() -> bool:
	enemy.front_ray.force_raycast_update()
	return enemy.front_ray.is_colliding()

func _detect_cliff() -> bool:
	enemy.edge_ray.force_raycast_update()
	return !enemy.edge_ray.is_colliding()

# 障碍处理
func _handle_obstacle() -> void:
	
	current_direction *= -1
	
	_update_ray_directions()
	enemy.navigation.target_position = patrol_points[0 if current_direction == 1 else 1]

func _update_ray_directions() -> void:
	enemy.front_ray.target_position.x *= -1
	enemy.edge_ray.target_position.x *= -1

func _reached_target() -> bool:
	var target = patrol_points[0 if current_direction == 1 else 1]
	return enemy.global_position.distance_to(target) < 5.0

func _switch_direction() -> void:
	
	current_direction *= -1
	enemy.navigation.target_position = patrol_points[0 if current_direction == 1 else 1]
	

# 初始化导航目标
func _enter() -> void:
	enemy.navigation.target_position = patrol_points[0]
