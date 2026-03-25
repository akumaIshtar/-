extends Node2D
var speed : float = 300
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var count : int
@onready var hit_box: HitBox = $HitBox
var is_player :bool = false
@onready var playerboom: AnimatedSprite2D = $Playerboom
@onready var boomboom: AnimatedSprite2D = $boomboom

var target : Enemy 
func _ready() -> void:
	boomboom.visible = false
	if is_player == true:
		anim.visible = false
		playerboom.visible = true
		playerboom.play("ready")
	else:
		playerboom.visible = false
		anim.visible = true
		
	if get_parent().enemy:
		target = get_parent().enemy
	else:
		await get_tree().create_timer(2.0).timeout
		queue_free()
	hit_box.body_entered.connect(_on_body_entered)
	
func _process(delta: float) -> void:
	if is_player == true:
		playerboom.play("player_bullet")
	else:
		anim.play("helper_bullet")
	if target  :
		if get_parent().global_position.x - target.global_position.x > 0:
			self.scale.x = -1
		else:
			self.scale.x = 1
		# 计算指向目标的方向向量
		var direction = (target.global_position - global_position + Vector2(0,-50)).normalized()
		if is_player == true:
			position += direction * speed * delta * 4
		else:
			position += direction * speed * delta * 2
	else:
		await get_tree().create_timer(2.0).timeout
		queue_free()
func set_count(i : int) -> void:
	count = i;
func _on_body_entered(p_body:Node2D):
	if p_body is Enemy :
		boomboom.visible = true
		anim.visible = false
		playerboom.visible = false
		boomboom.play("flash")
		await get_tree().create_timer(0.5).timeout
		queue_free()
		
