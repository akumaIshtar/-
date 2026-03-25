#================================================================================
# 管理游戏地图的节点
#================================================================================

extends Node

var map_dict: Dictionary = {
	0:{
		0: "res://Scene/Game/Map/Maps/map_0_0.tscn",
		1: "res://Scene/Game/Map/Maps/map_0_1.tscn",
		2: "res://Scene/Game/Map/Maps/map_0_2.tscn",
		3: "res://Scene/Game/Map/Maps/map_0_3.tscn",
		4: "res://Scene/Game/Map/Maps/map_0_4.tscn",
	},
}

var entry_index: int
var player_position: Vector2:
	set(v):
		print(v)
		player_position = v
var player_map_id: Vector2i

#================================================================================

func get_map_name() -> String:
	var map = get_tree().get_first_node_in_group("global_world_map") as WorldMap
	if map:
		return map.place_name
	else:
		return ""

func get_player_position() -> Vector2:
	var map := get_tree().get_first_node_in_group("global_world_map")
	return map.get_player_position_in_map()

func set_player_position(pos: Vector2) -> void:
	var map := get_tree().get_first_node_in_group("global_world_map")
	map.player.position = pos

#================================================================================
# 保存
func save_data() -> Dictionary:
	player_map_id = get_tree().get_first_node_in_group("global_world_map").place_id
	return {
		"player_position": get_player_position(),
		"player_map_id": player_map_id,
	}

func load_data(dict: Dictionary) -> void:
	for attribute in dict:
		set(attribute, dict[attribute])

#================================================================================
