class_name AttackAlert
extends Node2D

@export var mark:Sprite2D

func _ready() -> void:
	mark.modulate.a = 0.0

func attack_alert():
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(mark,"modulate:a",1.0,0.2)
	tween.tween_property(mark,"modulate:a",0.0,0.1)
	
