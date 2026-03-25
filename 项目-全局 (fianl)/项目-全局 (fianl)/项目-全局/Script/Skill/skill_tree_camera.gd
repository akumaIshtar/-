# res://skill_tree/camera_controller.gd
extends Camera2D

@export var move_speed := 100.0
@export var zoom_speed := 0.2
@export var boundary_rect := Rect2(-1500, -1000, 3000, 2000) # 根据技能树实际大小调整

var drag_start_pos := Vector2.ZERO
var is_dragging := false

func _ready():
	# 确保是当前摄像机
	make_current()
	boundary_rect = %ColorRect.get_rect()
	# 初始化位置到技能树中心
	#position = boundary_rect.get_center()

func _input(event):
	_handle_drag(event)
	_handle_zoom(event)

func _handle_drag(event):
	if event.is_action_pressed("right_click"):
		drag_start_pos = get_global_mouse_position()
		is_dragging = true
		get_viewport().set_input_as_handled() # 阻止事件穿透
	
	if event.is_action_released("right_click"):
		is_dragging = false
	
	if is_dragging and event is InputEventMouseMotion:
		var drag_offset = (drag_start_pos - get_global_mouse_position())
		_move_camera(drag_offset)
		drag_start_pos = get_global_mouse_position()

func _handle_zoom(event):
	if event.is_action_pressed("zoom_in"):
		_set_zoom(zoom * (1 + zoom_speed))
	elif event.is_action_pressed("zoom_out"):
		_set_zoom(zoom * (1 - zoom_speed))

func _move_camera(offset: Vector2):
	position += offset * move_speed * get_process_delta_time()
	_clamp_position()

func _set_zoom(new_zoom: Vector2):
	new_zoom = new_zoom.clamp(Vector2(0.6, 0.6), Vector2(3.0, 3.0))
	var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "zoom", new_zoom, 0.2)
	await tween.finished
	_clamp_position()

func _clamp_position():
	var viewport_size = get_viewport_rect().size / zoom
	position.x = clamp(position.x, 
		boundary_rect.position.x + viewport_size.x / 2,
		boundary_rect.end.x - viewport_size.x / 2
	)
	position.y = clamp(position.y,
		boundary_rect.position.y + viewport_size.y / 2,
		boundary_rect.end.y - viewport_size.y / 2
	)
