#================================================================================
# 技能管理节点
#================================================================================

extends Node

#================================================================================

signal skill_unlocked(skill_id: String)

const SKILL_FOLDER_PATH: String = "res://Resource/Customize/Skill/SkillResource/"

@export var skill_tree_data: Resource

var unlocked_skills: Array[String] = []  # 已解锁技能ID
var gained_attributes: Array[Dictionary] = [] #已获取的属性
var skill_resources: Dictionary = {}     # 加载的技能资源
var skill_point: int = 45
var unlocked_nodes: Array[String] = []

#================================================================================
func _ready():
#预加载所有技能资源(放在res://Resource/Customize/Skill/SkillResource/目录下)
	_load_skill_resources()

func _load_skill_resources():
	var dir = DirAccess.open(SKILL_FOLDER_PATH)
	for file in dir.get_files():
		if file.ends_with(".tres"):
			var skill: Skill = load(SKILL_FOLDER_PATH + file)
			skill_resources[skill.id] = skill

# 检查技能是否可解锁（Metroidvania能力依赖关键）
func can_unlock(skill_id: String) -> bool:
	var skill: Skill = skill_resources.get(skill_id)
	if not skill: return false
	
	if is_unlocked(skill_id): return false
	
	# 检查是否已解锁所有前置技能
	for req_id in skill.unlock_required:
		if not req_id in unlocked_skills:
			return false
	return true

func is_unlocked(skill_id: String) -> bool:
	return skill_id in unlocked_skills

# 解锁技能
func unlock_skill(skill_id: String) -> void:
	if skill_id in unlocked_skills: return
	if can_unlock(skill_id):
		unlocked_skills.append(skill_id)
		emit_signal("skill_unlocked", skill_id)

# 获取玩家当前可用的技能列表
func get_available_skills() -> Array[Skill]:
	return skill_resources.values().filter(
		func(skill: Skill): return skill.id in unlocked_skills
	)

#================================================================================
# 保存
func save_data() -> Dictionary:
	return {
		"skill_tree_data": skill_tree_data,
		"unlocked_skills": unlocked_skills,
		"gained_attributes": gained_attributes,
		"skill_point": skill_point,
		"unlocked_nodes": unlocked_nodes,
	}

func load_data(dict: Dictionary) -> void:
	for attribute in dict:
		set(attribute, dict[attribute])

#================================================================================
