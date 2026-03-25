#================================================================================
# 传送点，用于两场景间的传送
#================================================================================

class_name Teleport

extends Interactable

#================================================================================
@onready var game_data: Node = GameData
@onready var map_data: Node = GameData.map_data

@export var tele_scene_to: Vector2i
@export var entry_index: int

#================================================================================
func get_entry_pos() -> Vector2:
	return $Entry_point.global_position

func interacted() -> void:
	map_data.entry_index = entry_index
	game_data.change_to_map(tele_scene_to)
#================================================================================
