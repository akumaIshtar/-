#================================================================================
# 此节点为单个世界场景，需要多次实例化来构成世界地图
# 需要编写函数构筑世界以及设置信息
# 传送区域和交互物品信息需手动添加
#================================================================================

class_name WorldMap

extends Node2D

#================================================================================
@onready var map_data: Node = GameData.map_data
@onready var player_data: Node = GameData.player_data
@onready var camera = $Camera
@onready var player: Player = $Player
@onready var entries: Node2D = $Entries
@onready var player_layer: CanvasLayer = $PlayerLayer
@onready var player_stats_ui: Control = $PlayerLayer/PlayerStatsUI
@onready var color_rect: ColorRect = $PlayerLayer/ColorRect
@onready var color_rect_2: ColorRect = $PlayerLayer/ColorRect2
@onready var help_player: OverheadFollower = $Player/Help_Player

@export var place_id: Vector2i
@export var place_name: String
var is_advance : bool = true
var skill_panel: Node
var bag_panel: Node
var is_sanity :bool = true
var is_skill : bool = false
#================================================================================
func _ready() -> void:
	print(map_data.player_position)
	if map_data.player_position:
		update_player_pos(map_data.player_position)
		map_data.player_position = Vector2(0, 0)
	else:
		var pos = entries.get_child(map_data.entry_index).get_entry_pos()
		update_player_pos(pos)
	Music.bgm_play("bgm_2")
	
	#设置相机边界
	var used = $TileMap/Layer.get_used_rect().grow(-5)
	var tile_size = $TileMap/Layer.tile_set.tile_size
	camera.set_camera_limit(used, tile_size)
	#camera.limit_top = used.position.y * tile_size.y
	#camera.limit_bottom = used.end.y * tile_size.y
	#camera.limit_left = used.position.x * tile_size.x
	#camera.limit_right = used.end.x * tile_size.x
	
	camera.position = player.position
	camera.reset_smoothing()
	camera.force_update_scroll()

func _process(delta: float) -> void:
	if is_skill&& player_data.sanity < 100:
		player.check_key()
	if player_data.sanity >= 100 && is_sanity:
		start_control_sanity()
		print_debug(player_data.sanity)
		is_sanity = false
func _input(event: InputEvent) -> void:
	if event.is_action_released("advance")&& player_data.sanity < 100:
		player.help_skill = false
		player.is_attack_help = true
		Engine.time_scale = 1  # 50%速度
		finally_control()
		is_advance = true
		is_skill = false
		
	if event.is_action_pressed("advance")&& player_data.sanity < 100:
		if is_advance:
			start_control()
			await player.time_counter(0.3)
			is_advance = false
		player.help_skill = true
		Engine.time_scale = 0.01  # 50%速度
		is_skill = true
	

func start_control() -> void:
	var tween = get_tree().create_tween()
	
	tween.tween_callback(color_rect.set_visible.bind(true))
	tween.tween_property(color_rect.material,"shader_parameter/Progress", 0.9, 0.3)

func finally_control() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect.material,"shader_parameter/Progress", 1.5, 0.3)
	tween.tween_callback(color_rect.set_visible.bind(false))
func start_control_sanity() -> void:
	var tween = get_tree().create_tween()
	
	tween.tween_callback(color_rect_2.set_visible.bind(true))
	tween.tween_property(color_rect_2.material,"shader_parameter/Progress", 0.75, 0.3)
func finally_control_sanity() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect.material,"shader_parameter/Progress", 1.5, 0.3)
	tween.tween_callback(color_rect.set_visible.bind(false))
# 更新玩家信息
func update_player_pos(pos: Vector2) -> void:
	player.position = pos
	help_player.global_position = player.global_position + Vector2(-64, -150)
	camera.reset_smoothing()
	camera.force_update_scroll()

func get_player_position_in_map() -> Vector2:
	return player.position
#================================================================================
