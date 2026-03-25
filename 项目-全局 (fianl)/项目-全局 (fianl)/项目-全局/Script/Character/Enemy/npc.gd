class_name NPC
extends Enemy

@export var navigation:NavigationAgent2D
@export var idle_anim:StringName = "idle"
@export var run_anim:StringName = "run"
@export var jump_anim:StringName = "jump"
@export var bt_player:BTPlayer
@export var front_ray:RayCast2D
@export var edge_ray:RayCast2D
@onready var enemy_visible: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D



const BLOOD_PARTICLE = preload("res://Resource/EffectItems/blood.tscn")


var blackboard:Blackboard

func _ready() -> void:
	
	data.max_hp = 200
	data.hp = 200
	
	blackboard = bt_player.blackboard
	blackboard.bind_var_to_property(BBName.hp_var,data,"hp")
	
	
	data.enemy_damaged.connect(_on_enemy_damaged)
	
	enemy_visible.screen_entered.connect(_on_screen_entered)
	enemy_visible.screen_exited.connect(_on_screen_exited)

func _physics_process(delta: float) -> void:
	gravity(delta)
	select_movement_animation()

func move(desired_direction:Vector2):
	
	var move_direction = Vector2(desired_direction.x,0)
	var move_velocity = Vector2(move_direction.x*data.run_speed,velocity.y)
	velocity = move_velocity
	move_and_slide()

func jump():
	velocity.y +=data.jump_velocity


func select_movement_animation():
	
	if locked_animation:
		return 
	
	if velocity.is_zero_approx():
		animationPlayer.play(idle_anim)
	elif not velocity.is_zero_approx() && velocity.y==0:
		animationPlayer.play(run_anim)
	#elif not velocity.is_zero_approx() && velocity.y!=0:
		#animationPlayer.play(jump_anim)

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
	
func play_blood_particle(hit_direction:Vector2):
	var blood = BLOOD_PARTICLE.instantiate() as Node2D
	blood.global_position = global_position+Vector2(0,-40)
	blood.scale.x = -hit_direction.x
	get_parent().add_child(blood)
	
	


func _on_enemy_damaged(damage:int,position:Vector2):
	data.hp = max(data.hp-damage,0)
	print(data.hp)
	
