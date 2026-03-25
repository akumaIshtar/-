extends Node2D

@export var bt_player:BTPlayer

var blackboard:Blackboard

func _ready() -> void:
	if bt_player!=null:
		blackboard = bt_player.blackboard

func _physics_process(delta: float) -> void:
	var current_direction:Vector2 = blackboard.get_var(BBName.direction_var)
	
	if current_direction.x>0:
		scale.x=1.0
	elif current_direction.x<0:
		scale.x = -1.0
