class_name HitBox
extends Area2D

signal  hit(hurtbox)
@onready var player_data: Node = GameData.player_data
@export var player:Player

func  _init()->void :

	body_entered.connect(_on_body_entered)

	
func _on_body_entered(p_body:Node2D):
	if p_body is Enemy && !player_data.is_skill_damage && !player_data.h_is_skill_damage:
		p_body.data.enemy_damaged.emit(player_data.p_damage,self.global_position)
		print_debug(1)
		print_debug(player_data.is_skill_damage)
	elif p_body is Enemy && player_data.is_skill_damage && !player_data.h_is_skill_damage:
		p_body.data.enemy_damaged.emit(player_data.m_damage,self.global_position)
		print_debug(player_data.m_damage)
	elif p_body is Enemy:
		p_body.data.enemy_damaged.emit(player_data.s_damage,self.global_position)
		print_debug(player_data.s_damage)
		
