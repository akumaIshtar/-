#================================================================================
# 角色死亡面板
#================================================================================

extends Control

#================================================================================

@onready var game_data: Node = GameData
@onready var restart_button: Button = $V/V/RestartButton
@onready var exit_button: Button = $V/V/ExitButton

#================================================================================

func _on_restart_button_pressed() -> void:
	game_data.start_game_from_record(game_data.selected_record_id)

func _on_exit_button_pressed() -> void:
	game_data.change_to_scene_to_file(game_data.scene_dict["main_ui"])

#================================================================================
