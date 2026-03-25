#================================================================================
# 背包面板
#================================================================================

extends Control

#================================================================================

const PACKBAG_SLOT = preload("res://Scene/Packbag/packbag_slot.tscn")

@onready var item_data: Node = GameData.item_data
@onready var inventory: Resource = GameData.item_data.inventory

@onready var selected_item_icon: TextureRect = $H/P1/V/M1/H/SelectedItemIcon
@onready var name_label: Label = $H/P1/V/M1/H/V/NameLabel
@onready var use_button: Button = $H/P1/V/M1/H/V/H/UseButton
@onready var discard_button: Button = $H/P1/V/M1/H/V/H/DiscardButton
@onready var describe_label: Label = $H/P1/V/M2/DescribeLabel

@onready var grid_slots: GridContainer = $H/P2/M/V/GridSlots

var selected_slot: PackbagSlot

#================================================================================

func _ready() -> void:
	load_items()

# 装载道具
func load_items() -> void:
	for id in inventory.max_storage:
		var slot := PACKBAG_SLOT.instantiate()
		slot.slot_id = id
		slot.init_item(inventory.items[id])
		
		slot.selected.connect(select_item)
		
		grid_slots.add_child(slot)

# 选择物品
func select_item(slot: PackbagSlot) -> void:
	var item: Dictionary = slot.item
	if slot.item:
		if selected_slot and discard_button.pressed.is_connected(selected_slot.discard):
			discard_button.pressed.disconnect(selected_slot.discard)
		discard_button.pressed.connect(slot.discard)
		
		if selected_slot and selected_slot.updated.is_connected(update_selected_slot):
			selected_slot.updated.disconnect(update_selected_slot)
		slot.updated.connect(update_selected_slot)
		
		selected_slot = slot
		
		describe_label.set_text(selected_slot.item["description"])
		selected_item_icon.texture = item["icon"]
		
		use_button.visible = true
		use_button.disabled = not selected_slot.item["can_use"]
		discard_button.visible = true
		discard_button.disabled = not selected_slot.item["can_discard"]
	else:
		selected_slot = null
		describe_label.set_text("")
		selected_item_icon.texture = null
		
		use_button.visible = false
		use_button.disabled = false
		discard_button.visible = false
		discard_button.disabled = false

# 更新选中信息
func update_selected_slot() -> void:
	select_item(selected_slot)

#================================================================================
