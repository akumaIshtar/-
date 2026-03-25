#================================================================================
# 所有可交互物品的基类
# 创建可交互物品场景时使用此类作为父类
#================================================================================

class_name Interactable

extends Area2D

#================================================================================
var can_interact: bool = true:
	set(v):
		monitoring = v
		can_interact = v

#================================================================================
#交互函数
func interacted() -> void:
	pass

func _on_body_entered(body):
	if body is Player:
		(body as Player).regist_interactable_item(self)

func _on_body_exited(body):
	if body is Player:
		(body as Player).unregist_interactable_item(self)
#================================================================================
