extends CharacterBody2D
class_name OverheadFollower
#状态
enum State{
	KEEPSTATE = 1,
	IDEL,
	MOVE,
	ATTACK,
}
@onready var state_machine: StateMachine = $StateMachine
#主角色节点
@export var player : Player
@export var camera : Camera2D
#敌人节点
var enemy
## 跟随配置
@export_category("Follow Settings")
@export var vertical_offset: float = 150.0
@export var follow_smoothness: float = 5.0
@export var max_follow_speed: float = 150.0
#自身节点
@onready var _142341: Node2D = $"player"
@onready var anim_tree = $"player/Node2D/AnimationTree"
@onready var attack: CollisionShape2D = $HitBox/Attack
@onready var player_data: Node = GameData.player_data
@onready var attack_all: CollisionShape2D = $HitBox/Attack_all

## 私有变量
var _current_velocity: Vector2 = Vector2.ZERO
var player_current_scale : int = 1  # 明确用整数记录方向
var is_moving := false
var move_timer := 0.0
const MOVE_DEBOUNCE_TIME := 0.1  # 100毫秒缓冲时间
var skill_time : float
var skill_count : Array = [0,0,0,0]
#弹幕技能生成位置节点
@onready var marker_position: Marker2D = $player/Marker2D
@onready var marker_2d_2: Marker2D = $player/Marker2D2
@onready var marker_2d_3: Marker2D = $player/Marker2D3

@onready var ex_skill: AnimatedSprite2D = $AnimatedSprite2D

#================================================================================
#准备函数
func _ready():
	anim_tree.active = true  # 必须激活才能使用
	anim_tree.anim_player = $"player/Node2D/AnimationTree".get_path()  # 设置关联的AnimationPlayer
	set_as_top_level(true)  # 确保脱离父节点变换
	global_position = get_parent().global_position + Vector2(-64, -150)
	# 初始化时同步scale
	_142341.scale.x = player.direction
#================================================================================
#状态机函数
func transition_state(from: State, to: State) -> void:
	match to:
		State.IDEL:
			anim_tree["parameters/playback"].travel("Still")
		State.MOVE:
			anim_tree["parameters/playback"].travel("Move")
		State.ATTACK:
			release_skill(player.advance_key)
func tick_physics(state: State, delta) -> void:
	match state:
		State.IDEL:
			move( delta)
		State.MOVE:
			move(delta)
		State.ATTACK:
			pass
func get_next_state(state: State) -> int:
	match state:
		State.IDEL:
			if is_moving:
				return State.MOVE
			if player.is_attack_help:
				return State.ATTACK
		State.MOVE:
			if not is_moving:
				return State.IDEL
			if player.is_attack_help:
				return State.ATTACK
		State.ATTACK:
			if not player.is_attack_help:
				return State.IDEL
	return StateMachine.KEEP_CURRENT
#================================================================================
#移动函数
func move(delta : float):
	if velocity.length() >= 5.0:
		is_moving = true
		move_timer = MOVE_DEBOUNCE_TIME
	else:
		move_timer -= delta
		if move_timer <= 0.0:
			is_moving = false
	# 检测方向变化并更新scale
	if player.direction != player_current_scale:
		player_current_scale = player.direction
		_142341.scale.x  = player_current_scale
	
	var target_offset = Vector2(-64 * player.direction, -vertical_offset).rotated(get_parent().global_rotation)
	var target_position = get_parent().global_position + target_offset
	
	var to_target = target_position - global_position
	var desired_velocity = to_target * follow_smoothness
	_current_velocity = _current_velocity.lerp(
		desired_velocity, 
		clamp(delta * follow_smoothness, 0, 1)
	)
	
	if _current_velocity.length() > max_follow_speed:
		_current_velocity = _current_velocity.normalized() * max_follow_speed
		
	velocity = _current_velocity
	move_and_slide()
#================================================================================
#释放技能函数
func release_skill(advance_key : Array)->void:
	player.is_attack_help = true
	check_enemy()
	for i in advance_key:
		if i == "e" and player_data.skill_5:
			skill_count[0] += 1
			if skill_count[0] > 1:
				break
			cast(player_data.skill_5)
			skill_time = player_data.skill_5.continuetime
		elif i == "r" and player_data.skill_6:
			skill_count[1] += 1
			if skill_count[1] > 1:
				break
			cast(player_data.skill_6)
			skill_time = player_data.skill_6.continuetime
		elif i == "t" and player_data.skill_7:
			skill_count[2] += 1
			if skill_count[2] > 1:
				break
			cast(player_data.skill_7)
			skill_time = player_data.skill_7.continuetime
		elif i == "q" and player_data.skill_8:
			skill_count[3] += 1
			if skill_count[3] > 1:
				break
			cast(player_data.skill_8)
			skill_time = player_data.skill_8.continuetime
		await player.time_counter(skill_time)
		player_data.h_is_skill_damage = false

	player.is_attack_help = false
	advance_key.clear()
	skill_count.fill(0)

func cast(skill: Skill) -> void:
	if skill.spir_cost <= player_data.sp:
		if skill and not skill.left_time:
			skill.execute(self)
			player_data.is_skill_damage = true

	


	

func creat_bullet():
	anim_tree["parameters/playback"].travel("skill_1")
	await player.time_counter(1)
	var bullet_1 = preload("res://buttle_p2.tscn").instantiate()
	bullet_1.is_player = false
	var bullet_2 = preload("res://buttle_p2.tscn").instantiate()
	bullet_2.is_player = false
	var bullet_3 = preload("res://buttle_p2.tscn").instantiate()
	bullet_3.is_player = false
	bullet_1.set_count(1)
	bullet_2.set_count(2)
	bullet_3.set_count(3)
	bullet_1.global_position = $player/Marker2D.position
	bullet_2.global_position = $player/Marker2D2.position
	bullet_3.global_position = $player/Marker2D3.position
	self.add_child(bullet_1)
	self.add_child(bullet_2)
	self.add_child(bullet_3)
	if enemy:
		var original_global_position_1 = bullet_1.global_position
		var original_global_position_2 = bullet_2.global_position
		var original_global_position_3 = bullet_3.global_position
		bullet_1.top_level = true
		bullet_2.top_level = true
		bullet_3.top_level = true
		bullet_1.global_position = original_global_position_1
		bullet_2.global_position = original_global_position_2
		bullet_3.global_position = original_global_position_3
	

func is_combo(i :int,box : CollisionShape2D)->void:
	for j in range(i):
		attack_hit(box)
		await player.time_counter(0.16)

	
func attack_hit(box : CollisionShape2D)->void:
	
	box.disabled = false
	await player.time_counter(0.1)
	box.disabled = true

func check_enemy():
	if player_data.enemy_array.size()>0:
		enemy = check_min_enemy_distance()
	else:
		enemy = null
	pass
func check_min_enemy_distance() -> Enemy:
	var min_distance = 100000
	var min_enemy : Enemy = null
	for i in player_data.enemy_array:
		if i:
			var distance : float = player.global_position.distance_to(i.global_position)
			if distance < min_distance :
				min_distance = distance
				min_enemy = i
	return min_enemy
			
		
		
		
