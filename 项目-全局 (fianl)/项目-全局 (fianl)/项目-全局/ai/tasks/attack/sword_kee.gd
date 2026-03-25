@tool

extends BTAction

var boss:Boss
var animation:AnimationPlayer
var timer:float = 0.0
const SWORD_TIMER=0.95

func _setup() -> void:
	boss = agent as Boss
	animation = boss.find_child("AnimationPlayer") as AnimationPlayer

func _tick(delta: float) -> Status:
	if timer>SWORD_TIMER:
		timer = 0.0
		#boss.generate_sword()
		return SUCCESS
		
	animation.play("crouch_idle")
	timer+=delta
	
	return RUNNING
