#================================================================
# FSM有限自动机
# 用于管理对象状态的简易节点
# 父节点需包含一个枚举实现三个函数:
# enum State{...} 对象状态枚举
# transition_state(from: State, to: State) -> void: 动画改变时执行的行为
# tick_physics(state: State, delta) -> void: 根据状态每一帧执行对应行为
# get_next_state(state: State) -> State: 获取下一状态
#================================================================

class_name StateMachine

extends Node
#================================================================

const KEEP_CURRENT :int = -1

#当前状态
var current_state : int = 2:
	set(v):
		owner.transition_state(current_state, v)
		current_state = v
		state_time = 0

#状态持续时间
var state_time: float
var dash_cooldown : float = 1
var dash_timer : float
#================================================================
func ready() -> void:
	await owner.ready
	current_state = 0
	print(current_state)
	
func _physics_process(delta: float) -> void:
	while true:
		var next := owner.get_next_state(current_state) as int
		if next == KEEP_CURRENT:
			break
		current_state = next
	owner.tick_physics(current_state, delta)
	state_time += delta
	dash_timer -= delta
#================================================================
