#================================================================================
# 技能按钮
#================================================================================

class_name SkillSlot

extends TextureButton

#================================================================================
signal selected
signal equipped

@export var slot_id: int = -1
@onready var mouse_texture = $MouseTexture

var skill: Skill
var skill_texture: Texture2D

#================================================================================
#设置槽位信息
func set_skill(s: Skill) -> void:
	if s:
		skill = s
		skill_texture = s.icon
		self.texture_normal = s.icon
	else:
		skill = null
		skill_texture = null
		self.texture_normal = null

func set_mouse_texture_visiblility(i: bool) -> void:
	mouse_texture.visible = i

#按键事件
func _on_pressed() -> void:
	if equipped.has_connections():
		equipped.emit(self)
	elif skill:
		selected.emit(skill)
#================================================================================
