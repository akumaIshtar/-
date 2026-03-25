#================================================================================
# 物品库
#================================================================================

extends Resource

#================================================================================

var item_lib: Dictionary

#================================================================================

func add_to_item_lib(item: Item) -> void:
	item_lib[item.id] = {
		"id": item.id,
		"icon": item.icon,
		"max_stack": item.max_stack,
		"description": item.information,
		"can_use": item.can_use,
		"can_discard": item.can_discard,
	}

func get_item(id: String) -> Dictionary:
	return item_lib[id]

#================================================================================
