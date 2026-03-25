#================================================================================
# 自定义2D相机
#================================================================================

extends Camera2D

#================================================================================

@export var target: Node2D  # 跟随目标
@export var follow_speed: float = 2.0  # 跟随速度
@export var zoom_speed: float = 2.0  # 缩放速度

# 缩放控制参数
@export var min_zoom: Vector2 = Vector2(0.8, 0.8)  # 最小缩放级别
@export var max_zoom: Vector2 = Vector2(1.5, 1.5)  # 最大缩放级别
@export var zoom_step: float = 0.1  # 每次滚轮的缩放变化量

# 控制参数
var is_shaking: bool = false
var shake_intensity: float = 0.0
var shake_duration: float = 0.0
var shake_timer: float = 0.0

var target_zoom: Vector2 = Vector2.ONE  # 默认无缩放
var custom_position: Vector2 = Vector2.ZERO  # 用于覆盖跟随的位置

#================================================================================
func _input(event) -> void:
	# 鼠标滚轮缩放控制
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# 放大摄像机（数值变小）
			var new_zoom = target_zoom - Vector2(zoom_step, zoom_step)
			set_zoom_level(new_zoom.clamp(min_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# 缩小摄像机（数值变大）
			var new_zoom = target_zoom + Vector2(zoom_step, zoom_step)
			set_zoom_level(new_zoom.clamp(min_zoom, max_zoom))

func _ready():
	# 初始化目标缩放
	target_zoom = zoom
	# 确保摄像机不会超出限制
	position_smoothing_enabled = true

func _physics_process(delta) -> void:
	# 处理摄像机位置
	if not custom_position == Vector2.ZERO:
		# 使用自定义位置
		global_position = global_position.lerp(custom_position, follow_speed * delta)
	elif target:
		# 正常跟随目标
		global_position = global_position.lerp(target.global_position + Vector2(0, -100), follow_speed * delta)
	
	# 处理摄像机缩放
	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
	
	# 处理屏幕震动效果
	if is_shaking:
		_process_shake(delta)

# 设置边界
func set_camera_limit(rect: Rect2, tile_size: Vector2) -> void:
	limit_top = rect.position.y * tile_size.y
	limit_bottom = rect.end.y * tile_size.y
	limit_left = rect.position.x * tile_size.x
	limit_right = rect.end.x * tile_size.x

# 设置自定义位置（覆盖跟随）
func set_custom_position(pos: Vector2):
	custom_position = pos

# 重置为跟随目标
func reset_to_target():
	custom_position = Vector2.ZERO

# 设置缩放级别
func set_zoom_level(zoom_level: Vector2, instant: bool = false):
	target_zoom = zoom_level
	if instant:
		zoom = target_zoom

# 屏幕震动效果
func shake(intensity: float, duration: float):
	is_shaking = true
	shake_intensity = intensity
	shake_duration = duration
	shake_timer = 0.0

func _process_shake(delta):
	if shake_timer < shake_duration:
		offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		shake_timer += delta
	else:
		is_shaking = false
		offset = Vector2.ZERO

#================================================================================
