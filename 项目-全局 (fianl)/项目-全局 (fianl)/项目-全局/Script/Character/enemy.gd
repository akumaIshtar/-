class_name Enemy
extends CharacterBody2D

@export var data:EnemyData:
	set(v):
		if v!=null:
			data = v.duplicate(true)
		else:
			data = EnemyData.new()

@export var animatedsprite:AnimatedSprite2D
@export var animationPlayer:AnimationPlayer

@onready var player_data: Node = GameData.player_data
var locked_animation:bool = false
var is_on_screen : bool = false
var alert_mark:AttackAlert
const ALERT_MARK = preload("res://Scene/Character/Enemy/AttackAlert.tscn")

#霸体标识
var unstoppable:bool = false

func _physics_process(delta: float) -> void:
	gravity(delta)
	

func move(desired_direction:Vector2):
	
	var move_direction = Vector2(desired_direction.x,0)
	var move_velocity = Vector2(move_direction.x*data.run_speed,velocity.y)
	velocity = move_velocity
	move_and_slide()

func jump():
	velocity.y +=data.jump_velocity


func gravity(delta:float):
	if !is_on_floor():
		var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")  # 获取项目默认重力值
		velocity.y += gravity_value * delta  # 应用重力加速度

func lock_animation():
	locked_animation = true
func unlock_animation():
	locked_animation = false

func freeze_frame():
	FreezeFrameManager.trigger()

func _on_screen_entered() :
	is_on_screen = true
	player_data.enemy_array.append(self)

func _on_screen_exited():
	is_on_screen = false
	player_data.enemy_array.erase(self)

func attack_alert(p_position:Vector2):
	if alert_mark == null:
		alert_mark = ALERT_MARK.instantiate() as AttackAlert
		get_parent().add_child(alert_mark)
		alert_mark.global_position = p_position + Vector2(5,-110)
	alert_mark.global_position = p_position + Vector2(5,-110)
	alert_mark.attack_alert()
