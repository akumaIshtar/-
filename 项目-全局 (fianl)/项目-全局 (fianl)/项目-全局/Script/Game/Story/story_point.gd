#================================================================================
# 剧情触发点
# 使用时需实例化story_point, 并为其添加CollisionShape2D子节点
#================================================================================

class_name story_point

extends Area2D

#================================================================================
@export var story_level: Vector2i

@onready var game_data: Node = GameData
@onready var story_data: Node = GameData.story_data

var story_dict: Dictionary

#================================================================================
#设置剧情页
func set_story_page() -> void:
	story_dict = story_data.get_story_page_dict(story_level)

#触发剧情
func trigger() -> void:
	if not story_data.is_level_completed(story_level):
		print("level-" + str(story_level) + "complete")
		game_data.create_story_page(story_level)

#检测玩家是否进入触发剧情区域
func _on_body_entered(body) -> void:
	if body is Player:
		trigger()
		story_data.complete_level(story_level)
#================================================================================
