class_name PhantomStriker
extends Enemy

@export var navigation:NavigationAgent2D
@export var idle_anim:StringName = "idle"
@export var run_anim:StringName = "run"
@export var bt_player:BTPlayer
@export var front_ray:RayCast2D
@export var edge_ray:RayCast2D
@export var collision:CollisionShape2D

const BLOOD_PARTICLE = preload("res://Resource/EffectItems/blood.tscn")
const PUPERFOG_PARTICLE = preload("res://Resource/EffectItems/puperfog.tscn")
var tween:Tween
var blackboard:Blackboard


func _ready() -> void:
	
	data.max_hp = 100
	data.hp = 100
	
	blackboard = bt_player.blackboard
	blackboard.bind_var_to_property(BBName.hp_var,data,"hp")
	
	data.enemy_damaged.connect(_on_enemy_damaged)
	
	collision = find_child("CollisionShape2D") as CollisionShape2D

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

func play_blood_particle(hit_direction:Vector2):
	var blood = BLOOD_PARTICLE.instantiate() as Node2D
	blood.global_position = global_position+Vector2(0,-40)
	blood.scale.x = -hit_direction.x
	get_parent().add_child(blood)

func flash_tween(target_position:Vector2):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"global_position",target_position,0.01)

func dispersed_tween():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"modulate:a",0.0,0.5)
	
	

func appear_tween():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"modulate:a",1.0,0.5)
	
	collision.disabled = false

func play_puperfog_particle():
	var puperfog = PUPERFOG_PARTICLE.instantiate() as Node2D
	puperfog.global_position = global_position+Vector2(0,-40)
	get_parent().add_child(puperfog)

func _on_enemy_damaged(damage:int,position:Vector2):
	data.hp = max(data.hp-damage,0)
	print(data.hp)

func dispersed_from_world():
	modulate.a = 0.0
	collision.disabled = true
