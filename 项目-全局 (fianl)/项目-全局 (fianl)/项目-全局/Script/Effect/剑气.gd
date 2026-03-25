class_name 剑气
extends CharacterBody2D

@onready var area = $Area2D
var timer:float = 0.0
const LIVE_TIME = 1.0

func _physics_process(delta: float) -> void:
	timer+=delta
	if timer>LIVE_TIME:
		queue_free()
	if is_on_wall():
		queue_free()	
		
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Character && body!=null:
		SignalBus.sword_damaged.emit(body)
		
