@tool
class_name Thrust
extends BTAction

var boss:Boss
var animationPlayer:AnimationPlayer
var timer:float = 0.0
var detectionZone:DetectionZone
var collision:CollisionShape2D

const thrust_speed:float = 800.0
const attack2timer:float = 0.4

func _setup() -> void:
	boss = agent as Boss
	animationPlayer = boss.find_child("AnimationPlayer")
	detectionZone = boss.find_child("DetectionZone") as DetectionZone
	collision = detectionZone.find_child("CollisionShape2D")

func _tick(delta: float) -> Status:
	var direction = blackboard.get_var(BBName.direction_var)
	boss.velocity.x = thrust_speed*direction.x
	#animationPlayer.play("attack2")
	collision.disabled = true
	timer+=delta
	
	if timer>attack2timer:
		boss.velocity.x = 0.0
		timer = 0.0
		collision.disabled = false
		return SUCCESS
	return RUNNING
