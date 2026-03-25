#================================================================================
# 技能类
# 使用需配置所需信息
#================================================================================

class_name Skill

extends Resource

#================================================================================

@export var id: String = ""             # 技能唯一标识
@export var name: String = ""           # 显示名称
@export var holder: String = ""         # 技能所属
@export var icon: Texture2D             # 技能图标
@export var mana_cost: int = 10         # 魔法消耗
@export var spir_cost: int = 0          # 魂力消耗
@export var cooldown: float = 2.0       # 冷却时间
@export var infomation: String = ""     # 技能信息
@export var continuetime: float    # 辅助角色技能持续时间
@export var sanity_add : int
@export var power_up : bool
@export var unlock_required: Array[String] = []  # 解锁所需的前置技能
var equipped_index: int = -1

var left_time: float = 0:
	set(v):
		v = clampf(v, 0, cooldown)
		left_time = v
#================================================================================
func update_cooldown(delta: float) -> void:
	left_time -= delta

func reset_cooldown() -> void:
	left_time = cooldown

func get_progress() -> float:
	return left_time / cooldown

func get_info() -> String:
	var info = ""
	if mana_cost:
		info += "魔力消耗:" + str(mana_cost) + '\n'
	if spir_cost:
		info += "魂力消耗:" + str(spir_cost) + '\n'
	info += "冷却时间:" + str(cooldown) + "s" + '\n'
	info += infomation
	return info

#技能效果逻辑(需被子类重写)
func execute(caster: Node) -> void:
	reset_cooldown()
	var player_data: Node = GameData.player_data
	player_data.mp -= self.mana_cost
	player_data.sp -= self.spir_cost
	player_data.sanity += self.sanity_add
	if player_data.sanity >=100:
		player_data.sanity = 100
	push_warning("Skill not implemented!")
#================================================================================
