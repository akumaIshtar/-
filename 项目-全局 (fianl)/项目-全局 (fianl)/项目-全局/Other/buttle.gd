extends Node2D
var speed : float;
var is_follow :bool = false
@export var attack: CollisionShape2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@onready var shield: Sprite2D = $Shield

var direction : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_follow:
		shield.visible = true
		anim.visible = false 
	else:
		attack.disabled = false
		shield.visible = false
		anim.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_follow:
		position.x = get_parent().player.position.x + 10
		position.y = get_parent().player.position.y -45
	else:
		anim.scale.x = direction
		anim.play("SwordQi")
		position.x += speed * delta
	
	attack.disabled = false
	await get_tree().create_timer(1).timeout
	attack.disabled = true

func set_radius(_radius:float) ->void:
	if attack.shape == null && is_follow:
		attack.shape = CircleShape2D.new()
		attack.shape.radius = _radius
	elif attack.shape == null:
		attack.shape = RectangleShape2D.new()
		attack.shape.size.x = 140
		attack.shape.size.y = 143
