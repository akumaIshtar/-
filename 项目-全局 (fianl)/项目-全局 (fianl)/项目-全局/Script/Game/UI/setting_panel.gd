#================================================================================
# 设置面板
#================================================================================
class_name SettingPanel

extends Control

@onready var setting_panel: Control = self

var option_mode_window : bool = false
var option_mode_size : int = 0

#================================================================================
#窗口模式选项
func _on_window_mode_item_selected(index: int) -> void:
	option_mode_window = index

#窗口大小选项
func _on_window_size_item_selected(index: int) -> void:
	option_mode_size = index

#应用按键
func _on_apply_pressed() -> void:
	if option_mode_window:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if option_mode_size == 0:
		DisplayServer.window_set_size(Vector2i(1280,720),0)
	elif option_mode_size == 1:
		DisplayServer.window_set_size(Vector2i(11920,1080),0)
	else:
		DisplayServer.window_set_size(Vector2i(2560,1440),0)

#退出按键
func _on_set_up_exit_pressed() -> void:
	setting_panel.queue_free()

#================================================================================
