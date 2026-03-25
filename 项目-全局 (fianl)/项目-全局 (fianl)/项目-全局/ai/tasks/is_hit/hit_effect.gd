@tool
class_name HitEffect
extends BTAction

var enemy:Enemy
var original_material: Material
var hit_material: ShaderMaterial
var hit_timer: float = 0.0
var is_animating := false
var duration := 0.3
var shake_intensity :=4.0
var back_angle:=deg_to_rad(-12)
var flash_speed:=8.0
var hit_direction:Vector2

func _setup() -> void:
	enemy = agent as Enemy
	enemy.data.enemy_damaged.connect(_on_enemy_damaged)
	
	#original_material = enemy.material
	#hit_material = create_hit_material()
	
	#enemy.material = hit_material

func _tick(delta: float) -> Status:
	var hp = blackboard.get_var(BBName.hp_var)
	#if hit_material == null:
		#return FAILURE
	if hp<=0:
		return FAILURE
	
	if not is_animating:
		_start_hit_effect()
		return RUNNING
	hit_timer += delta
	#hit_material.set_shader_parameter("hit_time",ease(hit_timer/duration,1.5))
	#hit_material.set_shader_parameter("shake",randf_range(-1,1)*shake_intensity)
	
	
	
	#硬直期间阻断其他行为
	if hit_timer<duration&&enemy.unstoppable==false:
		_start_hit_effect()
		
		return RUNNING
	else:
		enemy.velocity.x = 0
		return SUCCESS
	
func _start_hit_effect():
	is_animating = true
	enemy.velocity.x = enemy.data.slide_speed*hit_direction.x
	enemy.move_and_slide()
	
func _exit() -> void:
	#enemy.material = original_material
	enemy.rotation = 0
	enemy.velocity.x = 0.0
	hit_timer = 0.0
	is_animating = false
	# 重置摄像机偏移
	#enemy.get_viewport().get_camera_3d().h_offset = 0
	#enemy.get_viewport().get_camera_3d().v_offset = 0

#func create_hit_material()->ShaderMaterial:
	#var hit_mat = ShaderMaterial.new()
	#var shadercode = load("res://Resource/Shader/HitEffecet/hit_effect.gdshader")
	#hit_mat.shader = shadercode
	#return hit_mat


func _on_enemy_damaged(damage:int,position:Vector2):
	
	var intensity = clamp(damage/100.0,0.1,1.0)
	SignalBus.camera_shake_requested.emit(intensity,0.5)
	
	if enemy.unstoppable==false:
		enemy.animationPlayer.play("hurt")
	
	
	
	hit_direction = (position - enemy.global_position).normalized()
	if hit_direction.x<0:
		hit_direction = Vector2.RIGHT
	elif hit_direction.x>0:
		hit_direction = Vector2.LEFT
	enemy.play_blood_particle(hit_direction)#喷血
