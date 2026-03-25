class_name AttackArea2D
extends Area2D

@export var npc:Enemy


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(p_body:Node2D):
	if p_body is Character:
		SignalBus.player_damaged.emit(npc.data.p_damage,npc)
		var intensity = clamp(npc.data.p_damage/100.0,0.1,1.0)
		SignalBus.camera_shake_requested.emit(intensity,0.5)
