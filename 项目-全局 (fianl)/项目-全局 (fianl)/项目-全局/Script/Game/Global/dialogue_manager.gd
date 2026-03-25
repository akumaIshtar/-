#================================================================================
# 对话管理
#================================================================================

extends Node

#================================================================================

const DIALOGUE_FOLDER_PATH: String = "res://Resource/Customize/Dialogue/DialogueResource/"
const DIALOGUE_BALLOON := preload("res://addons/dialogue_manager/example_balloon/example_balloon.tscn")

@export var diag_resource: Resource

#================================================================================

func _ready() -> void:
	_load_dialogue_resources()
	print(diag_resource.dialogue_lib)

# 加载
func _load_dialogue_resources():
	var dir = DirAccess.open(DIALOGUE_FOLDER_PATH)
	for file in dir.get_files():
		if file.ends_with(".dialogue"):                   
			var dialogue := load(DIALOGUE_FOLDER_PATH + file)
			diag_resource.add_dialogue_to_lib(file, dialogue)

# 创建对话
func create_dialogue_balloon(diag_res: String, diag_id: String) -> void:
	var dialogue: DialogueBalloon = DIALOGUE_BALLOON.instantiate()
	get_tree().get_first_node_in_group("global_world_map").add_child(dialogue)
	dialogue.start(diag_resource.dialogue_lib[diag_res + ".dialogue"], diag_id)

#================================================================================
# 保存
func get_save_data() -> void:
	pass

func set_save_data() -> void:
	pass

#================================================================================
