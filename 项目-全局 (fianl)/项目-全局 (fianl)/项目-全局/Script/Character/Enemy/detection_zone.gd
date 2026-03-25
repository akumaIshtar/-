class_name DetectionZone
extends Area2D
#检测玩家进入和离开


@export var bt_player:BTPlayer

var blackboard:Blackboard
var target:Character:
	set(value):
		target = value



func _ready() -> void:
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	blackboard = bt_player.blackboard
	blackboard.bind_var_to_property(BBName.target_var,self,"target",true)

func _on_body_entered(p_body:Node2D):
	if p_body is Character:
		target = p_body
	
func _on_body_exited(p_body:Node2D):
	if target == p_body:
		target = null

func get_target()->Player:
	var target_ref:WeakRef = weakref(target)
	if target_ref and target_ref.get_ref():
		return target_ref.get_ref()
	return null
	
