#================================================================================
# 可拾取物品
#================================================================================

class_name PickItem

extends Node2D

#================================================================================

@onready var item_data: Node = GameData.item_data

@onready var texture: Sprite2D = $Texture

@export var item_id: String

var speed: float = 10.0
var acceleration: float = 100.0
var target: Player

#================================================================================

func set_item(i: String) -> void:
	if i:
		item_id = i
		set_texture(item_data.get_item_dict()["icon"])
	else:
		item_id = ""
		set_texture(null)


func set_texture(pic: Texture) -> void:
	if pic:
		pic.texture = pic
	else:
		texture = null

func _process(delta: float) -> void:
	if target and target.is_inside_tree():
		position += delta * speed * self.position.direction_to(target.position)
		speed += delta * acceleration

func _on_attract_area_body_entered(body):
	if body is Player:
		if not target:
			target = body

func _on_collect_area_body_entered(body):
	if body is Player:
		item_data.add_item_to_inventory(item_id, 1)
		self.queue_free()

#================================================================================
