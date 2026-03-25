# signal_bus.gd
extends Node

# 可交互物体信号
signal interactable_entered(item: Interactable)
signal interactable_exited(item: Interactable)

# 其他全局信号也可以在这里定义
signal max_sp_changed #法力上限修改信号
signal sp_changed #法力值修改信号
signal max_hp_changed #生命上限修改信号
signal hp_changed #生命值修改信号
signal max_mp_changed #法力上限修改信号
signal mp_changed #法力值修改信号
signal hp_depleted#生命值耗尽信号

signal player_damaged#玩家受击信号
signal laser_damaged#激光击中信号，交给wizard处理
signal sword_damaged#剑气击中信号,交给boss处理

signal camera_shake_requested(intensity:float,duration:float)
