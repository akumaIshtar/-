
class_name IsHit
extends BTCondition


var enemy :Enemy
var isHit:bool = false


func _setup() -> void:
	enemy = agent as Enemy
	enemy.data.enemy_damaged.connect(_on_enemy_damaged)
	
func _tick(_delta: float) -> Status:
	if isHit == true:
		isHit = false
		return SUCCESS
	else:
		return FAILURE
	
	
	
func _on_enemy_damaged(damage:int,position:Vector2):
	isHit = true
	
	
	
