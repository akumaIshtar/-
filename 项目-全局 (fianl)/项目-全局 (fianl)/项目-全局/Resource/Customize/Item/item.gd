#================================================================================
# 物品类
# 使用需配置所需信息
#================================================================================

class_name Item

extends Resource

#================================================================================

@export var id: String = ""             # 物品唯一标识
@export var name: String = ""           # 显示名称
@export var icon: Texture2D             # 物品图标
@export var information: String = ""    # 物品信息
@export var max_stack: int = 1          # 物品最大堆叠

@export var can_use: bool = false       # 是否可使用
@export var can_discard: bool = true    # 是否可丢弃
@export var can_sell: bool = false      # 是否可出售

var amount: int = 0

#================================================================================
func get_info() -> String:
	var info = ""
	info += information
	return info

func duplicate_item() -> Item:
	var item: Item = Item.new()
	item.id = self.id
	item.name = self.name
	item.icon = self.icon
	item.information = self.information
	item.max_stack = self.max_stack
	item.can_use = self.can_use
	item.can_sell = self.can_sell
	item.can_discard = self.can_discard
	item.amount = 1
	return item

# 道具使用函数
func use_effect() -> void:
	pass
#================================================================================
