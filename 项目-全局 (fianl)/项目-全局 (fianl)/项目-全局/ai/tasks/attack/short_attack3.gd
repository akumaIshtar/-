@tool
extends BTAction

var boss : Boss
var animationPlayer: AnimationPlayer


var attack_timer:float = 0.0

const ATTACK3_ANIMATION_FINISHED_TIME =0.7


func _setup() -> void:
	boss = agent as Boss
	animationPlayer = boss.find_child("AnimationPlayer") as AnimationPlayer

func _tick(delta: float) -> Status:
		
	if animationPlayer == null:
		return FAILURE
		
	if attack_timer < ATTACK3_ANIMATION_FINISHED_TIME:
		animationPlayer.play("attack3")
	else:
		animationPlayer.play("idle")
		return SUCCESS
	attack_timer+=delta
	
	# 实时位移控制
	var distance = abs(boss.target.global_position.x - boss.global_position.x)
	var velocity = distance/ATTACK3_ANIMATION_FINISHED_TIME
	boss.velocity.x = velocity * (blackboard.get_var(BBName.direction_var)).x
	
	
	return RUNNING
	
func _exit() -> void:
	attack_timer = 0.0
