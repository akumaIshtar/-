#================================================================================
# 背包格子容器
#================================================================================

class_name PackbagSlot

extends TextureButton

#================================================================================

signal updated
signal selected

@export var slot_id: int

@onready var amount_label: Label = $AmountLabel

var item: Dictionary

#================================================================================

func init_item(i: Dictionary) -> void:
	await ready
	set_item(i)

func set_item(i: Dictionary) -> void:
	if i:
		item = i
		texture_normal = i.icon
		amount_label.set_text(str(i.amount))
		disabled = false
	else:
		disabled = true
		item = {}
		texture_normal = null
		amount_label.set_text("")
	if updated.has_connections():
		updated.emit()

func get_item_info() -> String:
	if item:
		return item["information"]
	else:
		return ""

func discard() -> void:
	if item:
		item["amount"] -= 1
		if not item["amount"]:
			item = {}
		set_item(item)

func _on_pressed():
	if selected.has_connections() and item:
		selected.emit(self)

#================================================================================
