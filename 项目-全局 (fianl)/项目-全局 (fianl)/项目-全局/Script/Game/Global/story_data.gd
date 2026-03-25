#================================================================================
# 管理游戏剧情的节点
#================================================================================

extends Node

#================================================================================

@export var story_resource: Resource

var story_progress: Dictionary

#================================================================================

func _ready() -> void:
	reset_progress()

#剧情页函数
func get_story_page_dict(level: Vector2i) -> Dictionary:
	return story_resource.story_dict[level.x][level.y]

#================================================================================
#管理剧情进度函数
#保存进度
func save_progress():
	var save_file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	save_file.store_var(story_progress)
	save_file.close()

#加载进度
func load_progress():
	if FileAccess.file_exists("user://save_game.dat"):
		var save_file = FileAccess.open("user://save_game.dat", FileAccess.READ)
		story_progress = save_file.get_var()
		save_file.close()
	else:
		print("No save file found.")

#完成进度
func complete_level(level: Vector2i) -> void:
	story_progress[level.x][level.y]["complete"] = true
	save_progress()

func is_level_completed(level: Vector2i) -> bool:
	return story_progress[level.x][level.y]["complete"]

#重置进度
func reset_progress():
	story_progress = story_resource.get_init_progress()
	save_progress()
#================================================================================
# 保存
func save_data() -> Dictionary:
	return story_resource.story_dict

func load_data(dict: Dictionary) -> void:
	story_resource.story_dict = dict

#================================================================================
