#====================================================================================================
# 用于在技能树中显示的技能节点
#====================================================================================================

class_name SkillNode

extends SkillTreeNode

#====================================================================================================

@onready var choose_button: TextureButton = $ChooseButton
@onready var light: ColorRect = $Light


var skill: Skill
var light_color: Color

#====================================================================================================

func set_node(s: Skill, color: Color =  Color(1, 1, 1, 1)) -> void:
	if s is Skill:
		skill = s
		choose_button.texture_normal = s.icon
		light_color = color

func set_light(has: bool, color: Color = Color(1, 1, 1, 1)) -> void:
	if not has:
		light.visible = false
	else:
		light.visible = true
		light.material.set("shader_parameter/color", color)

func set_state(state: int) -> void:
	match state:
		0:
			choose_button.material.set("shader_parameter/is_unlocked", false)
		1:
			choose_button.material.set("shader_parameter/is_unlocked", true)
			set_light(true, light_color)
		2: 
			choose_button.material.set("shader_parameter/is_unlocked", false)
			choose_button.material.set("shader_parameter/locked_brightness", 1.0)

func _on_choose_button_pressed():
	if selected.has_connections():
		selected.emit(self)

#====================================================================================================
