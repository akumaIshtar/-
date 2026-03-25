@tool
class_name GroundAttack
extends BTAction

var enemy : Enemy
var animationPlayer: AnimationPlayer
var detectionZone: DetectionZone

var attack_timer:float = 0.0

const ATTACK_ANIMATION_FINISHED_TIME = 1.6711

func _setup() -> void:
	enemy = agent as Enemy
	animationPlayer = enemy.find_child("AnimationPlayer") as AnimationPlayer
	detectionZone = enemy.find_child("DetectionZone") as DetectionZone
	animationPlayer.animation_finished.connect(_on_animation_finished)

func _tick(delta: float) -> Status:
	
	if attack_timer >= ATTACK_ANIMATION_FINISHED_TIME:
		animationPlayer.play("idle")
		#blackboard.set_var(BBName.can_attack,false)
		return FAILURE
		
	if animationPlayer == null:
		return FAILURE
		
	var target = detectionZone.get_target()
	# 常规攻击检测逻辑
	if target == null:
		return FAILURE
	
	# 启动新攻击
	animationPlayer.play("attack")
	attack_timer+=delta
	
	# 实时位移控制
	enemy.velocity.x = enemy.data.slide_speed * (blackboard.get_var(BBName.direction_var)).x
	enemy.move_and_slide()
	
	return RUNNING
	
func _exit() -> void:
	attack_timer = 0.0
	
func _on_animation_finished(anim_name:StringName):
	return SUCCESS
