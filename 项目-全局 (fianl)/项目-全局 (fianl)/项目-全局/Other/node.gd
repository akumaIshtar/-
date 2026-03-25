extends Node

@onready var timer_resource = preload("res://Resource/Customize/Skill/skill.gd").new()
func _ready():
	# 设置超时回调函数
	timer_resource.set_timeout_callback(_on_timeout)
	# 启动计时器
	timer_resource.start_timer(self)


func _on_timeout():
	print("Timer has timed out!")
