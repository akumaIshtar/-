class_name BossLaser
extends Node2D

@export var max_search_length: float = 3000.0
@export var max_width:float = 20.0
@export var fade_duration: float = 0.5
@export_group("Collision")
@export_flags_2d_physics var player_mask: int = 1 << 0


@export var raycast: RayCast2D
@export var line2d: Line2D
@export var collision_area: Area2D
@export var timer:Timer

var current_length: float = 0.0
var collision_point:Vector2 = Vector2(0.0,0.0)
var _current_tween: Tween
var collision:CollisionShape2D
var timer_has_start:bool = true
var laser_developed:bool = false

func _ready() -> void:
	initialize_laser()
	collision_area.body_entered.connect(_on_body_entered)
	collision = collision_area.find_child("CollisionShape2D")
	
func _physics_process(delta: float) -> void:
	#update_laser_extension(delta)
	#if collision_point!=Vector2.ZERO&&laser_developed:
		#collision_point += Vector2(0.0,-10.0)
	update_visual_components()

# 动态延伸激光（含碰撞检测）
func update_laser_extension(delta: float) -> void:
	
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		collision_point = raycast.get_collision_point()
		
		current_length = global_position.distance_to(collision_point)
	else:
		current_length = move_toward(current_length, max_search_length, 1500 * delta)

# 初始化激光参数
func initialize_laser() -> void:
	line2d.width = 5.0
	raycast.collision_mask = player_mask
	

func set_raycast_target(target:Vector2):
	var target_direction = Vector2(target+Vector2(0,-50)-global_position).normalized()
	raycast.target_position = target_direction*max_search_length
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		collision_point = raycast.target_position + Vector2(0,-50)
		
		current_length = global_position.distance_to(collision_point)
	else:
		current_length = move_toward(current_length, max_search_length, 1500)
	# 更新碰撞区域
	if collision_area.get_child_count() > 0:
		var shape = collision_area.get_child(0).shape
		if shape is RectangleShape2D:
			var length = global_position.distance_to(collision_point)
			var rotation_angle = target_direction.angle()
			shape.size = Vector2(line2d.width, current_length)
			collision_area.global_position = target+Vector2(0,-50)
			collision_area.rotation = rotation_angle+PI/2

func update_visual_components() -> void:
	var points = PackedVector2Array()
	points.append(Vector2.ZERO)
	points.append(collision_point)
	line2d.points = points
	
	
			


func _on_body_entered(body: Node) -> void:
	if body is Character && body!=null:
		SignalBus.laser_damaged.emit(body)

func shrink_laser():
	_current_tween.kill()
	_current_tween = create_tween().set_ease(Tween.EASE_IN)
	_current_tween.tween_property(line2d, "width", 0.0, fade_duration)
	_current_tween.tween_callback(queue_free)
	
func develop_laser()->void:
	laser_developed = true
	_current_tween = create_tween().set_ease(Tween.EASE_OUT)
	_current_tween.tween_property(line2d, "width", max_width, 0.3)
	if raycast.is_colliding():
		var body = raycast.get_collider()
		if body is Character && body!=null:
			SignalBus.laser_damaged.emit(body)
		
	if timer_has_start:
		timer.wait_time = 0.5
		timer.start()
		timer_has_start = false


func disable_collision()->void:
	collision.disabled = true
func enable_collision()->void:
	collision.disabled = false


func _on_timer_timeout() -> void:
	shrink_laser()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Character && body!=null:
		SignalBus.laser_damaged.emit(body)
