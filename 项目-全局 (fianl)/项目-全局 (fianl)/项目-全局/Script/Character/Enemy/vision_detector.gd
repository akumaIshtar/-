# vision_detector.gd
class_name VisionDetector
extends Node2D

@export_category("Vision Settings")
@export var vision_angle: float = 60.0    # 视野角度
@export var vision_distance: float = 500.0 # 视野距离
@export var ray_count: int = 7          # 射线数量
@export_flags("Obstacles", "Players") var collision_mask = 0b1001

var current_target: WeakRef

# 新增方向基准向量
var _facing_right: bool = true
var _base_direction: Vector2:
	get:
		return Vector2.RIGHT if _facing_right else Vector2.LEFT

func _physics_process(delta):
	# 同步父节点(Facing)的朝向
	_facing_right = sign(get_parent().scale.x) > 0
	
	var rays = _create_vision_rays()
	
	current_target = _scan_with_rays(rays)

# 修改后的射线生成逻辑
func _create_vision_rays() -> Array[Dictionary]:
	var rays : Array[Dictionary] = []
	
	# 基于当前朝向的基准方向
	var base_angle = _base_direction.angle()
	
	for i in ray_count:
		# 在基准方向基础上展开角度
		var angle_offset = lerp(-vision_angle/2, vision_angle/2, float(i)/(ray_count-1))
		var final_angle = base_angle + deg_to_rad(angle_offset)
		
		rays.append({
			"direction": Vector2.RIGHT.rotated(final_angle),  # 基于全局坐标系的方向
			"position": global_position  # 使用全局坐标确保位置正确
		})
		
	if Engine.is_editor_hint():
		var color = Color.GREEN if _facing_right else Color.ORANGE
		for ray in rays:
			var end = ray.direction * vision_distance
			draw_line(Vector2.ZERO, end, color, 2.0)
	return rays

# 扫描逻辑
func _scan_with_rays(rays: Array) -> WeakRef:
	var space = get_world_2d().direct_space_state
	var best_target: Player = null
	var min_distance = INF
	
	for ray in rays:
		var end_pos = ray.position + ray.direction * vision_distance
		var params = PhysicsRayQueryParameters2D.create(ray.position, end_pos, collision_mask)
		
		var result = space.intersect_ray(params)
		if result.has("collider") and result.collider is Player:
			var distance = ray.position.distance_to(result.position)
			if distance < min_distance:
				best_target = result.collider
				min_distance = distance
	
	return weakref(best_target) if best_target else null

# 获取当前有效目标
func get_target() -> Player:
	if current_target and current_target.get_ref():
		return current_target.get_ref() as Player
	return null
