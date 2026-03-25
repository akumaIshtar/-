#====================================================================================================
# 用于在技能树中显示属性的节点
#====================================================================================================

class_name AttributeNode

extends SkillTreeNode

#====================================================================================================

@onready var choose_button: TextureButton = $ChooseButton

var attribute: Dictionary

#====================================================================================================
func set_node(s, color: Color =  Color(1, 1, 1, 1)) -> void:
	if s is Dictionary:
		attribute = s
		choose_button.texture_normal = load(attribute["texture"])

func set_state(state: int) -> void:
	match state:
		0:
			choose_button.material.set("shader_parameter/is_unlocked", false)
		1:
			choose_button.material.set("shader_parameter/is_unlocked", true)
		2: 
			choose_button.material.set("shader_parameter/is_unlocked", false)
			choose_button.material.set("shader_parameter/locked_brightness", 1.0)

func get_info() -> String:
	var text: String = ""
	for a in attribute["attribute"]:
		text += a + "+" + str(attribute["attribute"][a]) + "\n"
	if attribute.has("description"):
		text += attribute["description"]
	return text

func _on_choose_button_pressed():
	if selected.has_connections():
		selected.emit(self)

#====================================================================================================
