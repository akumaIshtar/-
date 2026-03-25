class_name Laser
extends Node2D

@export var max_search_length: float = 1000.0
@export var max_width:float = 25.0
@export var fade_duration: float = 0.5
@export_group("Collision")
@export_flags_2d_physics var ground_mask: int = 1 << 0


@export var raycast: RayCast2D
@export var line2d: Line2D
@export var collision_area: Area2D
@export var timer:Timer

# 状态变量
var is_active := true
var current_length: float = 0.0
var _current_tween: Tween
var collision:CollisionShape2D

func _ready() -> void:
	initialize_laser()
	setup_collision_detection()
	collision = collision_area.find_child("CollisionShape2D") as CollisionShape2D

# 初始化激光参数
func initialize_laser() -> void:
	line2d.width = 10.0
	raycast.collision_mask = ground_mask
	
# 配置碰撞检测
func setup_collision_detection() -> void:
	raycast.target_position = Vector2(0, max_search_length)
	collision_area.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	update_laser_extension(delta)
	update_visual_components()

# 动态延伸激光（含碰撞检测）
func update_laser_extension(delta: float) -> void:
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		current_length = global_position.distance_to(collision_point)
		if is_active:
			handle_collision_stop()
	else:
		current_length = move_toward(current_length, max_search_length, 1500 * delta)

# 碰撞处理
func handle_collision_stop() -> void:
	if !is_active: return
	
	is_active = false

	#等待两秒
	timer.wait_time = 2.0
	timer.start()
	# 触发收缩动画
	timer.timeout.connect(_shrink_laser)

# 更新可视化组件
func update_visual_components() -> void:
	var points = PackedVector2Array()
	points.append(Vector2.ZERO)
	points.append(Vector2(0, current_length))
	line2d.points = points
	
	# 更新碰撞区域
	if collision_area.get_child_count() > 0:
		var shape = collision_area.get_child(0).shape
		if shape is RectangleShape2D:
			shape.size = Vector2(line2d.width, current_length)
			collision_area.position = Vector2(0, current_length/2)

func _on_body_entered(body: Node) -> void:
	if body is Character && body!=null:
		SignalBus.laser_damaged.emit(body)

func _shrink_laser():
	_current_tween.kill()
	_current_tween = create_tween().set_ease(Tween.EASE_IN)
	_current_tween.tween_property(line2d, "width", 0.0, fade_duration)
	_current_tween.tween_callback(queue_free)
	
func develop_laser()->void:
	_current_tween = create_tween().set_ease(Tween.EASE_OUT)
	_current_tween.tween_property(line2d, "width", max_width, 0.3)

func disable_collision()->void:
	collision.disabled = true
	
func enable_collision()->void:
	collision.disabled = false
