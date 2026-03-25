@tool
extends BTAction

var enemy : Enemy
var animationPlayer: AnimationPlayer


var attack_timer:float = 0.0

const ATTACK1_ANIMATION_FINISHED_TIME =0.85


func _setup() -> void:
	enemy = agent as Enemy
	animationPlayer = enemy.find_child("AnimationPlayer") as AnimationPlayer

func _tick(delta: float) -> Status:
		
	if animationPlayer == null:
		return FAILURE
		
	if attack_timer < ATTACK1_ANIMATION_FINISHED_TIME:
		animationPlayer.play("attack1")
	else:
		animationPlayer.play("idle")
		return SUCCESS
	attack_timer+=delta
	
	# 实时位移控制
	enemy.velocity.x = enemy.data.slide_speed * (blackboard.get_var(BBName.direction_var)).x
	
	
	return RUNNING
	
func _exit() -> void:
	attack_timer = 0.0
