class_name VisionArea
extends Area2D

var current_target:WeakRef
var target:Node2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	current_target = null
	
func _on_body_entered(p_body:Node2D):
	if p_body is Character:
		current_target = weakref(p_body)
		target = p_body
		

func _on_body_exited(p_body:Node2D):
	if target == p_body:
		#进入后一直追踪/只追踪一次
		#current_target = null
		target = null
		print("body lost")
	
# 获取当前有效目标
func get_target() -> Player:
	if current_target and current_target.get_ref():
		return current_target.get_ref() as Player
	return null
