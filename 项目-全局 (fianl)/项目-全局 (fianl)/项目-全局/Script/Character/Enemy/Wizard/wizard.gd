class_name Wizard
extends Enemy

@export var navigation:NavigationAgent2D
@export var idle_anim:StringName = "idle"
@export var run_anim:StringName = "run"
@export var bt_player:BTPlayer
@export var front_ray:RayCast2D
@export var edge_ray:RayCast2D

const BLOOD_PARTICLE = preload("res://Resource/EffectItems/blood.tscn")
const SOULORB = preload("res://Resource/EffectItems/WizardAttackEffect/SoulOrb.tscn")
const LASER = preload("res://Resource/EffectItems/WizardAttackEffect/Laser.tscn")

var blackboard:Blackboard
var soulorb:SoulOrb
var laser:Laser


func _ready() -> void:
	
	data.max_hp = 50
	data.hp = 50
	
	blackboard = bt_player.blackboard
	blackboard.bind_var_to_property(BBName.hp_var,data,"hp")
	
	
	data.enemy_damaged.connect(_on_enemy_damaged)
	
	SignalBus.laser_damaged.connect(_on_laser_damaged)

func _physics_process(delta: float) -> void:
	super(delta)
	select_movement_animation()
	

func select_movement_animation():
	
	if locked_animation:
		return 
	
	if velocity.is_zero_approx():
		animationPlayer.play(idle_anim)
	elif not velocity.is_zero_approx() && velocity.y==0:
		animationPlayer.play(run_anim)
	#elif not velocity.is_zero_approx() && velocity.y!=0:
		#animationPlayer.play(jump_anim)

func play_blood_particle(hit_direction:Vector2):
	var blood = BLOOD_PARTICLE.instantiate() as Node2D
	blood.global_position = global_position+Vector2(0,-40)
	blood.scale.x = -hit_direction.x
	get_parent().add_child(blood)

func generate_soulorb():
	soulorb = SOULORB.instantiate() as Node2D
	get_parent().add_child(soulorb)
	soulorb.global_position = global_position+Vector2(0,-200)
	soulorb.modulate.a =0.0
	

func soulorb_move(player_position:Vector2):
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	if soulorb!=null:
		tween.tween_property(soulorb,"modulate:a",1.0,0.5)
		tween.parallel().tween_property(soulorb,"global_position",Vector2(player_position.x,player_position.y-300),0.3)
		soulorb.update_shader_param()
	if laser!=null:
		tween.parallel().tween_property(laser,"global_position",Vector2(player_position.x,player_position.y-280),0.3)
		

func generate_laser_ray():
	laser = LASER.instantiate()as Laser
	if soulorb == null:
		return
	laser.global_position = soulorb.global_position
	laser.scale.x = soulorb.scale.x
	get_parent().add_child(laser)
	

func laser_develop()->bool:
	if laser!=null:
		laser.develop_laser()
		return true
	else:
		return false

func release_soulorb():
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(soulorb,"modulate:a",0.0,0.5)
	soulorb.update_shader_param()
	
	tween.tween_callback(
		func():
			if soulorb:
				soulorb.queue_free()
	)
	
	

func _on_enemy_damaged(damage:int,position:Vector2):
	data.hp = max(data.hp-damage,0)
	print(data.hp)

func _on_laser_damaged(p_body:Node2D):
	SignalBus.player_damaged.emit(data.p_damage,self)
