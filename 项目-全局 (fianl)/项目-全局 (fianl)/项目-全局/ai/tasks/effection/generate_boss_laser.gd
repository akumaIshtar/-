@tool
extends BTAction

var boss:Boss
var timer:float = 0.0
const GENERATE_TIME = 2.0

func _setup() -> void:
	boss = agent as Boss

func _enter() -> void:
	boss.velocity = Vector2.ZERO
	

func _tick(delta: float) -> Status:
	boss.generate_boss_laser()
	if boss.boss_laser!=null:
		return SUCCESS
	else:
		return FAILURE
	
