#================================================================================
# 玩家节点
# 目前只实现基本功能
#================================================================================

class_name Player

extends Character

#================================================================================
#方向
enum Direction{
	RIGHT = +1,
	LEFT = -1,
}

#状态
enum State{
	KEEPSTATE = 1,
	IDLE = 2,
	WALK,
	RUN,
	JUMP,
	WALL_SLIDING,
	WALL_JUMP,
	FALL = 8,
	DASH,
	LANDING,
	DROP,
	ATTACK_1,
	ATTACK_2,
	ATTACK_3,
	ATTACK_4,
	ATTACK_5,
	SKILL,
}

@onready var player_data: Node = GameData.player_data
#碰撞检测部件
@onready var foot_check: RayCast2D = $Graphics/FootCheck
@onready var hand_check: RayCast2D = $Graphics/HandCheck
@onready var hand_check_2: RayCast2D = $Graphics/HandCheck2

#角色
@onready var player: Node2D = $Graphics/MaleModel
@onready var graphics: Node2D = $Graphics
@onready var jump_request_timer: Timer = $JumpRequestTimer
var is_landing : bool = true
var can_interact: bool = true
var is_first_tick: bool = false
var is_advance : bool = true
var advance_cd : float = 10
# 添加墙跳相关变量
var wall_jump_direction: int = 1  # 记录墙跳方向
var wall_jump_timer: float = 0.0
@export var can_combo := false
var is_combo_requested := false

#状态机
@onready var state_machine: StateMachine = $StateMachine
var pre_state : int
#动画树
@onready var anim_tree = $Graphics/MaleModel/AnimationTree
@onready var anim = $Graphics/MaleModel/AnimatedSprite2D
#辅助角色
@export var is_attack_help: bool = false
var interactable_stack: Array = []
@export var advance_key = []

#获取重力加速度
var default_gravity = ProjectSettings.get("physics/2d/default_gravity") as float
#角色基础信息
var direction: Direction = Direction.RIGHT:
	set(v):
		graphics.scale.x = v * abs(scale.x)
		direction = v
var dash_dir : float
var drop_speed : float = 10
var run_time : float = 0;
var is_skill_state : int = 0
var charge_time : float = 0

var power_press : String
#攻击框
@onready var attack_1: CollisionShape2D = $Graphics/HitBox/Attack_1
@onready var attack_3: CollisionShape2D = $Graphics/HitBox/Attack_3
@onready var skill_1: CollisionShape2D = $Graphics/HitBox/Skill_1
var help_skill : bool = false
var position_y : float;
var enemy

var is_sanity : bool = true
var time : float = 5
@onready var anim_s: AnimatedSprite2D = $AnimatedSprite2D

#================================================================================
#准备函数
func _ready() -> void:
	player_data.max_hp = 100
	player_data.hp=100
	player_data.max_mp = 100
	player_data.mp=100
	player_data.max_sp = 100
	player_data.sp=100
	SignalBus.player_damaged.connect(_on_player_damaged)
	
	await get_parent().ready
	anim_tree.active = true  # 必须激活才能使用
	anim_tree.anim_player = $Graphics/MaleModel/AnimationPlayer.get_path()  # 设置关联的AnimationPlayer

#================================================================================
#处理事件
func _unhandled_input(event: InputEvent) -> void:
	#跳跃控制
	if event.is_action_pressed("move_jump")&&is_skill_state ==0:
		jump()
		jump_request_timer.start()
	if event.is_action_released("move_jump") and velocity.y < player_data.jump_velocity / 2:
		jump_request_timer.stop()
		velocity.y = player_data.jump_velocity / 2
	if event.is_action_pressed("attack") and can_combo:
		is_combo_requested = true
	#交互控制
	if event.is_action_pressed("interact"):
		interact()
	
	#技能控制
	if event.is_action_pressed("skill_1") and help_skill == false and not player_data.skill_1 == null:
		state_machine.current_state = State.SKILL
		if player_data.skill_1.power_up == true:
			power_press = "skill_1"
		cast(player_data.skill_1)
	if event.is_action_pressed("skill_2") and help_skill == false and not player_data.skill_2 == null:
		state_machine.current_state = State.SKILL
		if player_data.skill_2.power_up == true:
			power_press = "skill_2"
		cast(player_data.skill_2)
	if event.is_action_pressed("skill_3") and help_skill == false and not player_data.skill_3 == null:
		state_machine.current_state = State.SKILL
		if player_data.skill_3.power_up == true:
			power_press = "skill_3"
		cast(player_data.skill_3)
	if event.is_action_pressed("skill_4") and help_skill == false and not player_data.skill_4 == null:
		state_machine.current_state = State.SKILL
		if player_data.skill_4.power_up == true:
			power_press = "skill_4"
		cast(player_data.skill_4)
#控制dash
func dashdir_ctrl() ->void:
	if Input.get_axis("move_left","move_right") == 0:
		dash_dir = direction
	else :
		dash_dir = Input.get_axis("move_left","move_right")
	
#每帧移动函数
func move(gravity: float, delta: float) -> void:
	var movement := Input.get_axis("move_left","move_right")
	run_time -= 0.02
	if  state_machine.current_state == State.DASH:
		dashdir_ctrl()
		velocity.x = move_toward(player_data.dash_speed * dash_dir, movement * player_data.run_speed, player_data.acceleration * delta)
		velocity.y = 0
	elif state_machine.current_state == State.RUN:
		print_debug(run_time)
		if run_time <-2&&run_time>-2.5:
			player.position.y += 0.3
		if run_time <-1.5&&run_time>-2:
			player.position.y -= 0.3
		if run_time <= -3:
			run_time = 0
		velocity.x = move_toward(velocity.x, movement * player_data.run_speed, player_data.acceleration * delta)
		
	else:
		velocity.x = move_toward(velocity.x, movement * player_data.walk_speed, player_data.acceleration * delta)
	if state_machine.current_state == State.DROP:
		velocity.y += gravity * delta * drop_speed
	else:
		if is_skill_state == 1:
			anim.play("SprintSkill")
			velocity.y = 0
		else:
			velocity.y += gravity * delta
	if not is_zero_approx(movement):
		direction = Direction.LEFT if movement < 0 else Direction.RIGHT
	move_and_slide()
#设置速度函数
func setVelocity( _x:float, _y:float ) ->void:
	velocity.x = _x
	velocity.y = _y;
#站立函数
func stand(delta: float) ->void:
	if state_machine.state_time > 0.1417 && (state_machine.current_state == State.ATTACK_1||state_machine.current_state == State.ATTACK_2):
		var movement := Input.get_axis("move_left","move_right")
		if not is_zero_approx(movement):
			direction = Direction.LEFT if movement < 0 else Direction.RIGHT
	elif state_machine.state_time > 0.7 && state_machine.current_state == State.ATTACK_3:
		var movement := Input.get_axis("move_left","move_right")
		if not is_zero_approx(movement):
			direction = Direction.LEFT if movement < 0 else Direction.RIGHT
	else :
		if state_machine.current_state == State.ATTACK_1||state_machine.current_state == State.ATTACK_2:
			setVelocity(3.0 * direction,0)
		elif  state_machine.current_state == State.ATTACK_3:
			setVelocity(100.0 *direction,0)
		else:
			velocity.x = move_toward(velocity.x, 0.0, player_data.acceleration * delta)
			velocity.y = 0
			
	move_and_slide()
#跳跃函数
func jump() -> void:
	if is_on_floor():
		velocity.y += player_data.jump_velocity

#================================================================================
#释放技能
func cast(skill: Skill) -> void:
	if skill.mana_cost <= player_data.mp:
		player_data.is_skill_damage = true
		check_enemy()
		if skill and not skill.left_time:
			if skill.id == "0001":
				is_skill_state = 1
			elif skill.id =="0002":
				is_skill_state = 2
			elif skill.id =="0003":
				is_skill_state = 3
			elif skill.id =="0004":
				is_skill_state = 4
			skill.execute(self)
			
func skill_move(gravity: float, delta: float)->void:
	var movement := Input.get_axis("move_left","move_right")
	velocity.x = move_toward(velocity.x, movement * (100+charge_time*100), player_data.acceleration * delta)
	if not is_zero_approx(movement):
		direction = Direction.LEFT if movement < 0 else Direction.RIGHT
	velocity.y += gravity * delta 
	move_and_slide()
#================================================================================
#处理可交互物品
func interact() -> void:
	if can_interact and interactable_stack:
		(interactable_stack.back() as Interactable).interacted()

func regist_interactable_item(item: Interactable) -> void:
	interactable_stack.append(item)
	$F_Key.visible = true

func unregist_interactable_item(item: Interactable) -> void:
	interactable_stack.erase(item)
	if interactable_stack.is_empty():
		$F_Key.visible = false

#================================================================================
#状态机函数
func transition_state(from: State, to: State) -> void:
	match to:
		State.IDLE:
			anim_tree["parameters/playback"].travel("Normal_Stand")
		State.RUN:
			anim_tree["parameters/playback"].travel("Normal_Run")
		State.WALK:
			anim_tree["parameters/playback"].travel("Normal_Walk")
		State.JUMP:
			
			anim_tree["parameters/playback"].travel("Normal_Jump")
			velocity.y = player_data.jump_velocity
			jump_request_timer.stop()
		State.FALL:
			anim_tree["parameters/playback"].travel("Normal_Stagnation")
		State.WALL_JUMP:
			
			velocity.y = player_data.wall_jump_vertical_speed
			velocity.x = player_data.wall_jump_horizontal_speed * direction
			jump_request_timer.stop()
		State.LANDING:
			anim_tree["parameters/playback"].travel("Normal_Land")
		State.WALL_SLIDING:
			anim_tree["parameters/playback"].travel("Normal_OnWall")
		State.DROP:
			anim_tree["parameters/playback"].travel("Normal_QuickLand")
		State.DASH:
			anim_tree["parameters/playback"].travel("Normal_Dash")
			state_machine.dash_timer = state_machine.dash_cooldown
		State.ATTACK_1:
			Music.se_play("beat1")
			anim_tree["parameters/playback"].travel("attack_1")
			is_combo(1,attack_1,0.2,0.1)
		State.ATTACK_2:
			Music.se_play("beat2")
			anim_tree["parameters/playback"].travel("attack_2")
			is_combo(1,attack_1,0.2,0.1)
		State.ATTACK_3:
			Music.se_play("beat3")
			anim_tree["parameters/playback"].travel("attack_3")
			is_combo(2,attack_1,0.4,0.2)
		State.ATTACK_4:
			Music.se_play("beat2")
			anim_tree["parameters/playback"].travel("attack_4")
			is_combo(2,attack_1,0.2,0.1)
		State.ATTACK_5:
			Music.se_play("beat1")
			anim_tree["parameters/playback"].travel("attack_5")
			is_combo(2,attack_1,0.2,0.1)
		State.SKILL:
			pass
	is_first_tick = true

func tick_physics(state: State, delta) -> void:
	match state:
		State.IDLE:
			move(default_gravity, delta)
		State.RUN:
			move(default_gravity,delta)
		State.WALK:
			move(default_gravity, delta)
		State.JUMP:
			move(0.0 if is_first_tick else default_gravity, delta)
		State.FALL:
			move(default_gravity,delta)
		State.WALL_SLIDING:
			move(default_gravity/3,delta)
		State.WALL_JUMP:
			move(0.0 if is_first_tick else default_gravity, delta)
		State.DASH:
			move(default_gravity, delta)
		State.LANDING:
			stand(delta)
		State.DROP:
			move(default_gravity,delta)
		State.ATTACK_1:
			stand(delta)
		State.ATTACK_2:
			stand(delta)
		State.ATTACK_3:
			stand(delta)
		State.ATTACK_4:
			stand(delta)
		State.ATTACK_5:
			stand(delta)
			
		State.SKILL:
			if is_skill_state == 1 :
				charge_time += delta
				if Input.is_action_pressed(power_press):
					skill_move(1000,delta)
					anim_tree["parameters/playback"].travel("charge")
				if Input.is_action_just_released(power_press)&& charge_time <3 :
					anim_tree["parameters/playback"].travel("chargeLater")
					attack_1.disabled = false
					await  time_counter(0.1)
					attack_1.disabled = true
					await  time_counter(0.3)
					is_skill_state = 0
					charge_time = 0
					
				elif  charge_time >3:
					anim_tree["parameters/playback"].travel("chargeLater")
					attack_1.disabled = false
					await  time_counter(0.1)
					attack_1.disabled = true
					await  time_counter(0.3)
					is_skill_state = 0
					charge_time = 0
					
	is_first_tick = false

func get_next_state(state: State) -> int:
	var movement := Input.get_axis("move_left","move_right")
	var is_still := is_zero_approx(movement) and is_zero_approx(velocity.x)
	match state:
		State.IDLE:
			position_y = player.position.y
			
			if Input.is_action_pressed("run_toggle")&&movement != 0:
				is_landing = false
				run_time = 0
				return State.RUN
			if Input.is_action_just_pressed("dash")&&state_machine.dash_timer < 0:
				return State.DASH
			if Input.is_action_just_pressed("attack"):
				return State.ATTACK_1
			if not is_on_floor():
				return State.FALL
			if not is_still:
				return State.WALK
			if Input.is_action_just_pressed("move_jump"):
				return State.JUMP
		State.RUN:
			
			if Input.is_action_just_pressed("dash")&&state_machine.dash_timer < 0:
				is_landing = true
				player.position.y = position_y
				return State.DASH
			if movement ==0:
				player.position.y = position_y
				is_landing = true
				return State.IDLE
			if not is_on_floor()&&!hand_check_2.is_colliding():
				player.position.y = position_y
				is_landing = true
				return State.FALL
			if Input.is_action_just_pressed("move_jump"):
				player.position.y = position_y
				is_landing = true
				return State.JUMP
		State.WALK:
			
			if Input.is_action_pressed("run_toggle")&&movement != 0:
				is_landing = false
				run_time = 0
				return State.RUN
			if Input.is_action_just_pressed("dash")&&state_machine.dash_timer < 0:
				return State.DASH
			if Input.is_action_just_pressed("attack"):
				return State.ATTACK_1
			if not is_on_floor():
				return State.FALL
			if is_still:
				return State.IDLE
			if Input.is_action_just_pressed("move_jump"):
				return State.JUMP
			
		State.JUMP:
			
			if Input.is_action_just_pressed("dash")&&state_machine.dash_timer < 0:
				return State.DASH
			if velocity.y >= 0:
				return State.FALL
			if Input.is_action_just_pressed("drop"):
				return State.DROP
		State.FALL:
			
			if Input.is_action_just_pressed("dash")&&state_machine.dash_timer < 0:
				return State.DASH
			if is_on_floor():
				if is_still && is_landing:
					return State.LANDING
				else:
					return State.WALK
			if hand_check.is_colliding()and foot_check.is_colliding():
				return State.WALL_SLIDING
			if Input.is_action_just_pressed("drop"):
				return State.DROP
		State.WALL_SLIDING:
			
			if is_on_floor():
				return State.IDLE
			if not (hand_check.is_colliding() and foot_check.is_colliding()):
				return State.FALL
			if Input.is_action_just_pressed("jump"):
				return State.WALL_JUMP
		State.WALL_JUMP:
			
			if Input.is_action_just_pressed("dash")&&state_machine.dash_timer < 0:
				return State.DASH
			if velocity.y >= 0:
				return State.FALL
			
		State.DASH:
			
			if state_machine.state_time > 0.25:
				if is_still:
					return State.IDLE
				else:
					return State.WALK
				if not is_on_floor():
					return State.FALL
		State.LANDING:
			if state_machine.state_time > 0.1833 &&is_landing:
				return State.IDLE
		State.DROP:
			
			if is_on_floor():
				return State.IDLE
		State.ATTACK_1:
			player_data.is_skill_damage = false
			if state_machine.state_time > 0.1417&&Input.is_action_just_pressed("attack")&&state_machine.state_time < 0.4:
				return State.ATTACK_2
			if state_machine.state_time >= 0.4:
				return State.IDLE
			if not is_on_floor():
					return State.FALL
		State.ATTACK_2:
			
			if state_machine.state_time > 0.1417&&Input.is_action_just_pressed("attack")&&state_machine.state_time < 0.4:
				return State.ATTACK_3
			if state_machine.state_time >= 0.4:
				return State.IDLE
			if not is_on_floor():
					return State.FALL
		State.ATTACK_3:
			if state_machine.state_time > 0.65&&Input.is_action_just_pressed("attack")&&state_machine.state_time < 0.9:
				return State.ATTACK_4
			if state_machine.state_time >= 0.9:
				return State.IDLE
			if not is_on_floor():
					return State.FALL
		State.ATTACK_4:
			if state_machine.state_time > 0.42&&Input.is_action_just_pressed("attack")&&state_machine.state_time < 0.7:
				return State.ATTACK_5
			if state_machine.state_time >= 0.7:
				return State.IDLE
			if not is_on_floor():
					return State.FALL
		State.ATTACK_5:
			if state_machine.state_time > 0.9:
				return State.IDLE
			if not is_on_floor():
					return State.FALL
		State.SKILL:
			if is_skill_state == 0:
				#player_data.is_skill_damage = false
				return State.IDLE
	return StateMachine.KEEP_CURRENT
#================================================================================
#================================================================================
#计时器函数
func time_counter(wait_time : float):
	await get_tree().create_timer(wait_time).timeout
#================================================================================

#创造剑气
func creat_bullet(speed : float,_radius : float,time : float,_is_follow : float):
	var bullet_1 = preload("res://buttle.tscn").instantiate()
	
	bullet_1.is_follow = _is_follow
	bullet_1.set_radius(_radius)
	bullet_1.direction = direction
	bullet_1.speed = speed * direction
	bullet_1.global_position = $Marker2D.global_position
	get_parent().add_child(bullet_1)
	if bullet_1.is_follow == true:
		is_combo(30,skill_1,0.1,0.2) 
	await time_counter(time)
	if _is_follow:
		bullet_1.queue_free()
	else:
		bullet_1.queue_free()
#创造弹幕
func creat_bullet_skill()->void:
	var bullet_1 = preload("res://buttle_p2.tscn").instantiate()
	bullet_1.is_player = true
	bullet_1.global_position = $Player_buttle.position
	self.add_child(bullet_1)
	if enemy:
		var original_global_position_1 = bullet_1.global_position
		bullet_1.top_level = true
		bullet_1.global_position = original_global_position_1
	await time_counter(1)
func _process(delta: float) -> void:
	time -= delta
	if time < 0 && player_data.sanity <100 :
		player_data.sp +=5
		player_data.mp +=10
		player_data.hp +=1
		player_data.sanity -= 1
		time = 5
	sanity_number()
func sanity_number()->void:
	if time < 0 && player_data.sanity >= 100:
		player_data.hp -=2
		if is_sanity:
			player_data.p_damage += 30
			player_data.m_damage += 50
			is_sanity = false
		time = 1
func _on_player_damaged(damage:int,attacker:Enemy):
	player_data.hp = max(player_data.hp-damage,0)
	
	#击退效果
	if attacker!=null:
		var back_direction = (global_position-attacker.global_position).normalized()
#进程函数

#输入技能判断
func check_key()->void:
	if Input.is_action_just_pressed("skill_1"):
		advance_key.append("e")
	if Input.is_action_just_pressed("skill_2"):
		advance_key.append("r")
	if Input.is_action_just_pressed("skill_3"):
		advance_key.append("t")
	if Input.is_action_just_pressed("skill_4"):
		advance_key.append("q")
func is_combo(i :int,box : CollisionShape2D,time : float,time_cd : float)->void:
	for j in range(i):
		print(i)
		attack_hit(box,time_cd)
		await time_counter(time)
func attack_hit(box : CollisionShape2D,time_cd : float)->void:
	box.disabled = false
	await time_counter(time_cd)
	box.disabled = true
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
func check_enemy():
	if player_data.enemy_array.size()>0:
		enemy = check_min_enemy_distance()
	else:
		enemy = null
