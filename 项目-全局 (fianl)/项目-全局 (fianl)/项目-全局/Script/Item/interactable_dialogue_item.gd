#================================================================================
# 交互对话物品
#================================================================================

class_name InteractableDialogueItem

extends Interactable

#================================================================================

@onready var dialogue_manager: Node = GameData.dialogue_manager

@export var dialogue_resource_name: String
@export var dialogue_name: String
@export var dialogue_name_replaced: String
@export var is_talked: bool

#================================================================================

func interacted() -> void:
	if not is_talked:
		dialogue_manager.create_dialogue_balloon(dialogue_resource_name, dialogue_name)
		is_talked = true
	else:
		if dialogue_name_replaced:
			dialogue_manager.create_dialogue_balloon(dialogue_resource_name, dialogue_name)

#================================================================================
