class_name SoulOrb
extends Node2D

@onready var sprite = $Sprite2D
var shader_material = ShaderMaterial

func _ready() -> void:
	shader_material = sprite.material as ShaderMaterial
	

func update_shader_param():
	shader_material.set_shader_parameter("modulate_a",modulate.a)
	
	
	
	
