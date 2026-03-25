#================================================================================
# 库存资源
#================================================================================

extends Resource

#================================================================================

signal inventory_updated

@export var items: Array[Dictionary] = []  # 库存槽位数组
@export var max_storage: int = 36

var used_slot: int = 0

#================================================================================

func get_used_slot() -> int:
	var num: int = 0
	for i in items:
		if i:
			num += 1
	return num

func add_item(new_item: Dictionary) -> bool:
	used_slot = get_used_slot()
	
	# 尝试堆叠已有物品
	while new_item["amount"]:
		for item in items:
			if item:
				if new_item["id"] == item["id"] and item["amount"] < item["max_stack"]:
					while item["amount"] < item["max_stack"]:
						item["amount"] += 1
						new_item["amount"] -= 1
						if not new_item["amount"]:
							new_item = {}
							inventory_updated.emit()
							return true
						
		
		# 尝试储存
		if used_slot >= max_storage:
			return false
		else:
			for item in items:
				if not item:
					var new := new_item.duplicate()
					new["amount"] = 1
					items[items.find(item)] = new
					
					new_item["amount"] -= 1
					used_slot += 1
					inventory_updated.emit()
					break
	
	return false
#================================================================================
