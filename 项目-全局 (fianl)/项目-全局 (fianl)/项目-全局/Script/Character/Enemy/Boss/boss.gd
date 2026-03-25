class_name Boss
extends Enemy

@export var navigation:NavigationAgent2D
@export var idle_anim:StringName = "idle"
@export var run_anim:StringName = "run"

@export var bt_player:BTPlayer
@export var front_ray:RayCast2D
@export var edge_ray:RayCast2D
@export var vision:VisionDetector
@export var laser_mark:Marker2D

@onready var game_data: Node = GameData

const BLOOD_PARTICLE = preload("res://Resource/EffectItems/blood.tscn")
const SWORD_KEE = preload("res://Resource/EffectItems/BossAttackEffect/剑气.tscn")
const LASER = preload("res://Resource/EffectItems/BossAttackEffect/BossLaser.tscn")

var sword:剑气
var boss_laser:BossLaser
var target:Player
var blackboard:Blackboard

func _ready() -> void:
	
	data.max_hp = 600
	data.hp = 600
	data.slide_speed = 20
	
	blackboard = bt_player.blackboard
	blackboard.bind_var_to_property(BBName.hp_var,data,"hp")
	
	
	data.enemy_damaged.connect(_on_enemy_damaged)
	
	SignalBus.sword_damaged.connect(_on_sword_damaged)
	SignalBus.laser_damaged.connect(_on_laser_damaged)
	
	unstoppable = true
	

func _physics_process(delta: float) -> void:
	super(delta)
	select_movement_animation(delta)
	
	#初见锁定玩家
	if target == null:
		target = vision.get_target()
		
	
	move_and_slide()

func select_movement_animation(delta:float):
	
	if locked_animation:
		return 
	
	if velocity.is_zero_approx():
		animationPlayer.play(idle_anim)
	elif not velocity.is_zero_approx() && velocity.y==0:
		animationPlayer.play(run_anim)
		friction_used(delta)
	#elif not velocity.is_zero_approx() && velocity.y!=0:
		#animationPlayer.play(jump_anim)

func friction_used(delta:float):
	velocity.x = move_toward(velocity.x,0.0,data.friction*delta)

func play_blood_particle(hit_direction:Vector2):
	var blood = BLOOD_PARTICLE.instantiate() as Node2D
	blood.global_position = global_position+Vector2(0,-40)
	blood.scale.x = -hit_direction.x
	get_parent().add_child(blood)

func generate_sword():
	var direction = blackboard.get_var(BBName.direction_var)
	
	sword = SWORD_KEE.instantiate() as 剑气
	get_parent().add_child(sword)
	sword.global_position = Vector2(global_position.x+direction.x*50,global_position.y-50)
	sword.velocity.x = 500*direction.x
	sword.velocity.x = move_toward(sword.velocity.x,800*direction.x,50)
	sword.scale = Vector2(1.5*direction.x,1.5)

func generate_boss_laser():
	if boss_laser==null:
		boss_laser = LASER.instantiate() as BossLaser
		get_parent().add_child(boss_laser)
	boss_laser.global_position = laser_mark.global_position
	boss_laser.set_raycast_target(target.global_position)
	
func laser_search():
	if boss_laser.laser_developed == false:
		boss_laser.set_raycast_target(target.global_position)

func laser_enable():
	boss_laser.raycast.enabled = true
	
func laser_develop()->bool:
	if boss_laser!=null:
		boss_laser.develop_laser()
		return true
	else:
		return false

func _on_enemy_damaged(damage:int,position:Vector2):
	data.hp = max(data.hp-damage,0)
	print(data.hp)
	
func _on_sword_damaged(p_body:Node2D):
	SignalBus.player_damaged.emit(data.p_damage*2,self)
	var intensity = clamp(data.p_damage*2/100.0,0.1,1.0)
	SignalBus.camera_shake_requested.emit(intensity,0.5)
func _on_laser_damaged(p_body:Node2D):
	SignalBus.player_damaged.emit(data.p_damage*0.1,self)


func _on_tree_exiting():
	game_data.chenge_to_scene_to_file(game_data.scene_dict["demo_end_ui"])
