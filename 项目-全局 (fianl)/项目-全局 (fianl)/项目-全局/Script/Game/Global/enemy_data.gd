#================================================================
# Player节点为记录角色信息节点
# 将
# 本节点包括角色属性
#================================================================
class_name EnemyData
extends Resource

#================================================================
# 角色属性部分

#生命值-----------------------------------------------------------

var max_hp: int: #生命上限
	set(v):
		v = clampi(v, 0 ,9999)
		if not v == max_hp:
			SignalBus.max_hp_changed.emit(v)
		max_hp = v

signal enemy_damaged(damage:int,position:Vector2)
signal hp_changed(hp:int)
var hp: int: #生命值
	set(v):
		v = clampi(v, 0 ,max_hp)
		if not v == hp:
			hp_changed.emit(v)
		hp = v

#法力值-----------------------------------------------------------

var max_mp: int: #法力上限
	set(v):
		v = clampi(v, 0 ,9999)
		if not v == max_mp:
			SignalBus.max_mp_changed.emit(v)
		max_mp = v


var mp: int: #法力值
	set(v):
		v = clampi(v, 0 ,max_mp)
		if not v == mp:
			SignalBus.mp_changed.emit(v)
		mp = v

#魂力值-----------------------------------------------------------

var max_sp: int: #法力上限
	set(v):
		v = clampi(v, 0 ,9999)
		if not v == max_sp:
			SignalBus.max_sp_changed.emit(v)
		max_sp = v


var sp: int: #法力值
	set(v):
		v = clampi(v, 0 ,max_sp)
		if not v == sp:
			SignalBus.sp_changed.emit(v)
		sp = v

#----------------------------------------------------------------
@export_category("Ground Settings")
const run_speed: float = 500
const walk_speed: float = 100
const jump_velocity: float = -600
const acceleration: float = 5000
const friction:float = 8000
@export var acceleration_curve: Curve  # 在编辑器绘制曲线


@export_category("Jump Settings")

const air_accel :float = 3000.0  # 空中加速度

const fast_fall_multiplier :float= 10 # 快速下落

const air_resistance :float= 50  # 空气摩擦


# 伤害属性(物理-p-physics, 法力-m-magical, 魂力-s-spiritual)
@export_category("Damage Settings")
var p_damage_rate: float = 1 #角色物理伤害加成
var m_damage_rate: float = 1 #角色魔法伤害加成
var p_damage: int = 10 #角色普通攻击造成的伤害

#攻击时滑动速度
@export_category("攻击时滑动")
var slide_speed:float = 5

#受击效果
@export var hit_material:Material

	
#================================================================
