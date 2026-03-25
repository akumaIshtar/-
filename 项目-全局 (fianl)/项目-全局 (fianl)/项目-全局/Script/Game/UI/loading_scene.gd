#================================================================================
# 加载界面
# 调用GameData内的 load_to_scene 时使用
#================================================================================

extends Control

@onready var game_data: Node = GameData
@onready var loading_bar: TextureProgressBar = $LoadingBar

var load_status: Array
var scene_to: String
var is_ready: bool = false
var is_passed: bool = false
var tween: Tween

#================================================================================
func _ready() -> void:
	scene_to = game_data.next_scene
	ResourceLoader.load_threaded_request(scene_to)

func _process(_delta: float) -> void:
	var load_state = ResourceLoader.load_threaded_get_status(scene_to, load_status)
	if load_state == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		is_ready = true
		tween = get_tree().create_tween()
		tween.tween_property($Label, "modulate:a", 1, 1)

func _unhandled_key_input(_event) -> void:
	if is_ready and not is_passed:
		is_passed = true
		var packed_scene = ResourceLoader.load_threaded_get(scene_to)
		game_data.change_to_scene_to_packed(packed_scene)
#================================================================================
