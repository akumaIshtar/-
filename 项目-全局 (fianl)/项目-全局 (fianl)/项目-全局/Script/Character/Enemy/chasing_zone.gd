class_name ChasingZone
extends Area2D
#检测玩家，决定是否追踪

signal target_detected(target:Node)
signal target_lost()

@export var bt_player:BTPlayer

var blackboard:Blackboard
var chase_target:Character:
	set(value):
		chase_target = value


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	blackboard = bt_player.blackboard
	blackboard.bind_var_to_property(BBName.chase_target_var,self,"chase_target",true)
	

func _on_body_entered(p_body:Node2D):
	if p_body is Character:
		chase_target = p_body
		target_detected.emit(weakref(chase_target))
		
		

func _on_body_exited(p_body:Node2D):
	if chase_target == p_body:
		chase_target = null
		target_lost.emit()
