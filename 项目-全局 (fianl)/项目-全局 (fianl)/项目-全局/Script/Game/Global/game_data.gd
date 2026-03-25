#================================================================================
# GameData节点是全局静态节点
# 在其他节点中加入以下代码即可调用:
#   @onready var game_data: Node = GameData
# 本节点包括全局变量、全局函数
#================================================================================

extends Node

#================================================================================
const SAVE_PATH: String = "user://"
const RECORD_NAME: String = "packed_save_data"
const RECORD_SUFFIX: String = ".tres"
const RECORD_DATA_PATH: String = "user://record_data.tres"

@onready var player_data: Node = $PlayerData
@onready var story_data: Node = $StoryData
@onready var map_data: Node = $MapData
@onready var skill_data: Node = $SkillData
@onready var item_data: Node = $ItemData
@onready var dialogue_manager: Node = $DialogueManager

@onready var change_scene_rect: ColorRect = $Canvas/ChangeSceneRect
@onready var canvas: CanvasLayer = $Canvas



#储存场景路径的字典
var scene_dict: Dictionary = {
	"game_map": "res://Scene/Game/Map/world_scene.tscn",
	"loading_scene": "res://Scene/Game/UI/loading_scene.tscn",
	"story_page": "res://Scene/Game/Story/page_story_animation_panel.tscn",
	"option_ui": "res://Scene/Game/UI/option_panel.tscn",
	"main_ui": "res://Scene/Game/UI/main_ui.tscn",
	"set_ui": "res://Scene/Game/UI/setting_panel.tscn",
	"skill_panel": "res://Scene/Skill/skill_panel.tscn",
	"die_ui":"res://Scene/Game/UI/die_panel.tscn",
	"demo_end_ui":"res://Scene/Game/UI/demo_end_panel.tscn",
}

var next_scene: String
var tween: Tween

var setting_panel: SettingPanel
var option_panel: OptionPanel

var record_dict: Dictionary = {
	1: {},
	2: {},
	3: {},
}
var record_data: RecordData
var selected_record_id: int


#================================================================================
func _ready() -> void:
	change_scene_rect.color.a = 0
	load_record_data()

#检测按键输入
func _unhandled_input(event) -> void:
	if event.is_action_pressed("esc"):
		if not option_panel:
			create_option_panel()
			get_tree().paused = true
		else:
			option_panel.queue_free()
			get_tree().paused = false

#================================================================================
#场景切换函数
func load_to_scene(scene_to: String) -> void:
	next_scene = scene_to
	change_to_scene_to_file(scene_dict["loading_scene"])

func change_to_scene_to_file(scene_to: String) -> void:
	tween = get_tree().create_tween()
	get_tree().paused = true
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(change_scene_rect, "color:a", 1, 1)
	tween.tween_callback(get_tree().change_scene_to_file.bind(scene_to))
	tween.tween_property(change_scene_rect, "color:a", 0, 1)
	await tween.finished
	get_tree().paused = false

func change_to_scene_to_packed(scene_to) -> void:
	tween = get_tree().create_tween()
	get_tree().paused = true
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(change_scene_rect, "color:a", 1, 1)
	tween.tween_callback(get_tree().change_scene_to_packed.bind(scene_to))
	tween.tween_property(change_scene_rect, "color:a", 0, 1)
	await tween.finished
	get_tree().paused = false

func change_to_map(to: Vector2i) -> void:
	var path = map_data.map_dict[to.x][to.y]
	change_to_scene_to_file(path)

#================================================================================
#创建剧情页
func create_story_page(level: Vector2) -> void:
	var story_page_scene = load(scene_dict["story_page"]).instantiate()
	story_page_scene.get_animation(story_data.get_story_page_dict(level))
	canvas.add_child.call_deferred(story_page_scene)

#UI
func create_setting_panel() -> void:
	if not setting_panel:
		setting_panel = load(scene_dict["set_ui"]).instantiate()
		canvas.add_child(setting_panel)

func create_option_panel() -> void:
	if not option_panel:
		option_panel = load(scene_dict["option_ui"]).instantiate()
		canvas.add_child(option_panel)
#================================================================================
# 保存
func save_game_data(file_name: String) -> void:
	var save_data = SaveData.new()
	var time_dict = Time.get_datetime_dict_from_system()
	var time: String = (
		str(time_dict["year"]) + "-" +
		str(time_dict["month"]) + "-" +
		str(time_dict["day"]) + " " +
		str(time_dict["hour"]) + ":" +
		str(time_dict["minute"]) + ":" +
		str(time_dict["second"])
	)
	var save_dict: Dictionary = {
		"place": map_data.get_map_name(),
		"time": time,
	}
	
	record_data.records[selected_record_id] = save_dict
	ResourceSaver.save(record_data, RECORD_DATA_PATH)
	
	save_data.player_data = player_data.save_data()
	save_data.story_data = story_data.save_data()
	save_data.map_data = map_data.save_data()
	save_data.skill_data = skill_data.save_data()
	save_data.item_data = item_data.save_data()
	
	ResourceSaver.save(save_data, SAVE_PATH + file_name)
	
	print("Game is saved to path: " + SAVE_PATH + file_name)

func load_game_data(file_name: String) -> bool:
	if not ResourceLoader.exists(SAVE_PATH + file_name):
		player_data.init_attribute()
		return false
	
	ResourceLoader.load_threaded_request(SAVE_PATH + file_name)
	await ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED
	var data = ResourceLoader.load_threaded_get(SAVE_PATH + file_name) as SaveData
	
	player_data.load_data(data.player_data)
	story_data.load_data(data.story_data)
	map_data.load_data(data.map_data)
	skill_data.load_data(data.skill_data)
	item_data.load_data(data.item_data)
	
	print("Game is loaded from path: " + SAVE_PATH + file_name)
	return true

func load_record_data() -> void:
	if not ResourceLoader.exists(RECORD_DATA_PATH):
		record_data = RecordData.new()
	else:
		record_data = ResourceLoader.load(RECORD_DATA_PATH) as RecordData
		record_dict = record_data.records

#================================================================================
# 开始
func start_new_game() -> void:
	load_to_scene(map_data.map_dict[0][0])

func start_game_from_record(record_id: int) -> void:
	var file_name: String = RECORD_NAME + str(record_id) + RECORD_SUFFIX
	var game_loaded: bool = await load_game_data(file_name)
	if game_loaded:
		print("record_id" + str(record_id))
		var id_x: int = map_data.player_map_id.x
		var id_y: int = map_data.player_map_id.y
		load_to_scene(map_data.map_dict[id_x][id_y])
	else:
		start_new_game()

func save_game() -> void:
	var file_name: String = RECORD_NAME + str(selected_record_id) + RECORD_SUFFIX
	save_game_data(file_name)

#================================================================================
