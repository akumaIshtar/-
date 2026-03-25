#================================================================================
# 世界道具信息
#================================================================================

extends Node

#================================================================================

const ITEM_FOLDER_PATH: String = "res://Resource/Customize/Item/ItemResource/"

@export var item_lib: Resource
@export var inventory: Resource

var lib: Dictionary

#================================================================================

func _ready() -> void:
	_load_item_resources()

func _load_item_resources():
	inventory.items.resize(inventory.max_storage)
	var dir = DirAccess.open(ITEM_FOLDER_PATH)
	for file in dir.get_files():
		if file.ends_with(".tres"):
			var item: Item = load(ITEM_FOLDER_PATH + file)
			item_lib.add_to_item_lib(item)
	lib = item_lib.item_lib

func add_item_to_inventory(item_id: String, num: int) -> void:
	var item: Dictionary = item_lib.get_item(item_id)
	item["amount"] = num
	inventory.add_item(item)

func get_item_dict(id: String) -> Dictionary:
	return lib[id]

#================================================================================
# 保存
func save_data() -> Dictionary:
	var dict: Dictionary = {}
	for i in inventory.items:
		dict[inventory.items.find(i)] = i
	return dict

func load_data(dict: Dictionary) -> void:
	for i in dict:
		if dict[i]:
			inventory.items[i] = dict[i]

#================================================================================
