#===============================================================================
#用于定义黑板变量的名字
class_name BBName

#输入方向
static var direction_var :StringName = "direction"


#跳跃输入
static var jump_var: StringName = "jump"
#跳跃计数
static var jump_count:StringName = "jumpcount"

#强制下落输入
static var force_down:StringName = "forcedown"

#攀爬计时
static var climb_timer:StringName = "climbTimer"
#攀爬状态标志
static var can_climb:StringName = "canClimb"
#限制墙壁跳跃转换到空中后立即转换回墙壁
static var can_transition_to_air = "can_transition_to_air"

#攻击
static var attack:StringName = "attack"

#移动
static var can_move:StringName = "can_move"

#冲刺
static var dash:StringName = "dash"
#冲刺冷却标志
static var can_dash:StringName = "can_dash"

#面向方向
static var flip_h:StringName = "fliph"

#玩家目标
static var target_var:StringName = "target"
#追踪玩家目标
static var chase_target_var:StringName = "chase_target"
#敌人生命
static var hp_var:StringName = "hp"

#幻影攻击手原位置
static var source_position:StringName = "source_position"
static var can_flash:StringName = "can_flash"
static var can_attack:StringName = "can_attack"

#霸体标识
static var unstoppable:StringName = "unstoppable"

#技能冷却
static var cooldown_duration:StringName = "cooldown"
