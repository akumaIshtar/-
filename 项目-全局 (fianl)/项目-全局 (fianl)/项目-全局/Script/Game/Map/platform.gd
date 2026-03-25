class_name platform
extends StaticBody2D

@onready var area = $Area2D
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var disappear_timer = $DisappearTimer
@onready var reappear_timer = $ReappearTimer

var is_active := true  # 控制平台是否可用

func _ready():
	# 初始化计时器配置
	disappear_timer.wait_time = 1.0
	reappear_timer.wait_time = 0.5
	disappear_timer.one_shot = true
	reappear_timer.one_shot = true
	
# 平台隐藏
func _on_disappear_timer_timeout():
	is_active = false
	sprite.hide()
	print("1")
	collision_shape.set_deferred("disabled", true)  
	reappear_timer.start()

# 平台重新出现
func _on_reappear_timer_timeout():
	is_active = true
	sprite.show()
	collision_shape.disabled = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_active && body is Player:
		if body.global_position.y<global_position.y:
			disappear_timer.start()
