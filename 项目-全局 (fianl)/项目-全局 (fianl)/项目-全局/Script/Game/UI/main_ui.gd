#================================================================================
# 主界面
#================================================================================

extends Control

#================================================================================

@onready var game_data: Node = GameData
@onready var player_data: Node = GameData.player_data
@onready var map_data: Node = GameData.map_data
@onready var record_select_panel: Control = $CanvasLayer/RecordSelectPanel

@export var main_scene :String

var option_mode_window : bool = false
var option_mode_size : int = 0

#================================================================================
#退出按键
func _on_exit_pressed() -> void:
	get_tree().quit()

#开始按键
func _on_start_pressed() -> void:
	record_select_panel.visible = true
	record_select_panel.mouse_filter = Control.MOUSE_FILTER_STOP

#设置按键
func _on_set_up_pressed() -> void:
	game_data.create_setting_panel()

#================================================================================

func _on_continue_button_button_up():
	game_data.start_new_game()

#================================================================================
