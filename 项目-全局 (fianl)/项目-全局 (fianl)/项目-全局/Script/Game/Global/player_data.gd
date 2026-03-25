#================================================================
# Player节点为记录角色信息节点
# 在其他节点中加入以下代码即可调用:
#   @onready var player_data: Node = GameData.player_data
# 本节点包括角色属性
#================================================================
class_name PlayerData
extends Node
#================================================================
# 角色属性部分

var attribute_name: Dictionary = {
	"最大生命值": "max_hp",
	"最大法力值": "max_mp",
	"最大魂力值": "max_sp",
	"攻击力": "p_damage",
	"法力强度": "m_damage",
	"魂力强度": "s_damage",
}

#生命值-----------------------------------------------------------
signal max_hp_changed #生命上限修改信号
var max_hp: int = 100: #生命上限
	set(v):
		print("max_hp" + str(v))
		v = clampi(v, 0 ,9999)
		if not v == max_hp:
			max_hp_changed.emit(v)
		max_hp = v
		
signal hp_changed #生命值修改信号
var hp: int = 50: #生命值
	set(v):
		v = clampi(v, 0 ,max_hp)
		if v <= 0:
			GameData.change_to_scene_to_file(GameData.scene_dict["die_ui"])
		if not v == hp:
			hp_changed.emit(v)
		hp = v

#法力值-----------------------------------------------------------
signal max_mp_changed #法力上限修改信号
var max_mp: int: #法力上限
	set(v):
		v = clampi(v, 0 ,9999)
		if not v == max_mp:
			max_mp_changed.emit(v)
		max_mp = v

signal mp_changed #法力值修改信号
var mp: int: #法力值
	set(v):
		v = clampi(v, 0 ,max_mp)
		if not v == mp:
			mp_changed.emit(v)
		mp = v

#魂力值-----------------------------------------------------------
signal max_sp_changed #法力上限修改信号
var max_sp: int: #法力上限
	set(v):
		v = clampi(v, 0 ,9999)
		if not v == max_sp:
			max_sp_changed.emit(v)
		max_sp = v

signal sp_changed #法力值修改信号
var sp: int: #法力值
	set(v):
		v = clampi(v, 0 ,max_sp)
		if not v == sp:
			sp_changed.emit(v)
		sp = v

signal sanity_changed 
var sanity: int: 
	set(v):
		v = clampi(v, 0 ,100)
		if not v == sanity:
			sanity_changed.emit(v)
		sanity = v
#----------------------------------------------------------------
var Shield : int = 0
var run_speed: float = 600
var walk_speed: float = 200
var jump_velocity: float = -500
var acceleration: float = 5000
var dash_speed : float = 1000
# 伤害属性(物理-p-physics, 法力-m-magical, 魂力-s-spiritual)
var p_damage_rate: float = 1 #角色物理伤害加成
var m_damage_rate: float = 1 #角色魔法伤害加成
var s_damage_rate: float = 1 #辅助角色伤害加成
var p_damage: int = 10 #角色普通攻击造成的伤害
var m_damage: int = 10#角色技能造成的伤害
var s_damage: int = 10 #辅助角色技能造成的伤害
var is_skill_damage : bool = false
var h_is_skill_damage : bool = false
var wall_slide_speed: float = 100.0  # 墙滑最大下落速度
var wall_jump_vertical_speed: float = -600.0  # 墙跳垂直速度
var wall_jump_horizontal_speed: float = -600  # 墙跳水平速度


var enemy_array = []

func add_attribute(attribute: Dictionary) -> void:
	for a in attribute:
		set(attribute_name[a], get(attribute_name[a]) + attribute[a])

func init_attribute() -> void:
	max_hp = 100
	max_mp = 100
	max_sp = 100
	hp = max_hp
	mp = max_mp
	sp = max_sp
	sanity = 0
	p_damage_rate = 1
	m_damage_rate = 1
	s_damage_rate = 1
	p_damage = 10
	m_damage = 10
	s_damage = 10
	skill_1 = null
	skill_2 = null
	skill_3 = null
	skill_4 = null
	skill_5 = null
	skill_6 = null
	skill_7 = null
	skill_8 = null

#================================================================
# 技能
signal skill_changed

var skill_1: Skill:
	set(v):
		if not v == skill_1 and skill_changed.has_connections():
			skill_changed.emit(0, v.icon)
		skill_1 = v
var skill_2: Skill:
	set(v):
		if not v == skill_2 and skill_changed.has_connections():
			skill_changed.emit(1, v.icon)
		skill_2 = v
var skill_3: Skill:
	set(v):
		if not v == skill_3 and skill_changed.has_connections():
			skill_changed.emit(2, v.icon)
		skill_3 = v
var skill_4: Skill:
	set(v):
		if not v == skill_4 and skill_changed.has_connections():
			skill_changed.emit(3, v.icon)
		skill_4 = v
var skill_5: Skill:
	set(v):
		if not v == skill_5 and skill_changed.has_connections():
			skill_changed.emit(4, v.icon)
		skill_5 = v
var skill_6: Skill:
	set(v):
		if not v == skill_6 and skill_changed.has_connections():
			skill_changed.emit(5, v.icon)
		skill_6 = v
var skill_7: Skill:
	set(v):
		if not v == skill_7 and skill_changed.has_connections():
			skill_changed.emit(6, v.icon)
		skill_7 = v
var skill_8: Skill:
	set(v):
		if not v == skill_8 and skill_changed.has_connections():
			skill_changed.emit(7, v.icon)
		skill_8 = v
#================================================================
func _process(delta: float) -> void:
	if skill_1:
		skill_1.update_cooldown(delta)
	if skill_2:
		skill_2.update_cooldown(delta)
	if skill_3:
		skill_3.update_cooldown(delta)
	if skill_4:
		skill_4.update_cooldown(delta)
	if skill_5:
		skill_5.update_cooldown(delta)
	if skill_6:
		skill_6.update_cooldown(delta)
	if skill_7:
		skill_7.update_cooldown(delta)
	if skill_8:
		skill_8.update_cooldown(delta)
#强制更新技能
func update_skill_request(holder: String) -> void:
	match holder:
		"P1":
			skill_changed.emit(0, skill_1.icon if skill_1 else null)
			skill_changed.emit(1, skill_2.icon if skill_2 else null)
			skill_changed.emit(2, skill_3.icon if skill_3 else null)
			skill_changed.emit(3, skill_4.icon if skill_4 else null)
		"P2":
			skill_changed.emit(0, skill_5.icon if skill_5 else null)
			skill_changed.emit(1, skill_6.icon if skill_6 else null)
			skill_changed.emit(2, skill_7.icon if skill_7 else null)
			skill_changed.emit(3, skill_8.icon if skill_8 else null)

#================================================================================
# 保存
func save_data() -> Dictionary:
	var save_dict: Dictionary = {
		"max_hp": max_hp,
		"max_mp": max_mp,
		"max_sp": max_sp,
		"hp": hp,
		"mp": mp,
		"sp": sp,
		"sanity": sanity,
		"p_damage": p_damage,
		"m_damage": m_damage,
		"s_damage": s_damage,
		"p_damage_rate": p_damage_rate,
		"m_damage_rate": m_damage_rate,
		"s_damage_rate": s_damage_rate,
		
		"skill_1": skill_1,
		"skill_2": skill_2,
		"skill_3": skill_3,
		"skill_4": skill_4,
		"skill_5": skill_5,
		"skill_6": skill_6,
		"skill_7": skill_7,
		"skill_8": skill_8,
	}

	return save_dict

func load_data(dict: Dictionary) -> void:
	for attribute in dict:
		set(attribute, dict[attribute])


#================================================================================
