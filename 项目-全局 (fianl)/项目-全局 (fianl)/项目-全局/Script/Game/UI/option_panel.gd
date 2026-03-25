#================================================================================
# 选项面板
#================================================================================

class_name OptionPanel

extends Control

#================================================================================
@onready var game_data: Node = GameData
@onready var player_data: Node = GameData.player_data
@export var player: Player

#================================================================================
#退出选项
func _on_exit_button_button_up():
	game_data.change_to_scene_to_file(game_data.scene_dict["main_ui"])
	queue_free()

#设置选项
func _on_set_button_button_up():
	var set_up_scene = load(game_data.scene_dict["set_ui"])
	var set_up_instance = set_up_scene.instantiate()
	add_child(set_up_instance)


#取消选项
func _on_cancel_button_button_up():
	self.visible = false
#================================================================================
