class_name PageStoryAnimationPanel

extends Control

#================================================================================
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text: Label = $Text
@onready var texture: TextureRect = $Texture
@onready var pause_timer: Timer = $PauseTimer
#================================================================================
#将剧情页信息储存在字典队列内
#e.g.
#{1: {"content": "胖琛不胖", 
#"type": "text",
#"time": 3.0}｝

var page_story_dict: Dictionary = {}

var tween: Tween
var is_animation_loaded: bool = false
var page_queue: Array = [] #剧情页队列
var animation_queue: Array = [] #动画队列
var time_queue: Array = [] #时间队列

#================================================================================
func _ready() -> void:
	get_tree().paused = true
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate:a", 1, 1.0)
	tween.tween_callback(next_animation)

#退出函数
func quit() -> void:
	get_tree().paused = false
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.0)
	tween.tween_callback(queue_free)

#下一个动画
func next_animation() -> void:
	if not animation_queue.is_empty():
		animation_player.play(animation_queue.pop_front())
	else:
		quit()

#从全局载入动画--------------------------------------------------------------------
func get_animation(dict: Dictionary) -> void:
	page_story_dict = dict
	load_animation()

#解析字典装载动画-------------------------------------------------------------------
func load_animation() -> void:
	for index in page_story_dict:
		var dict: Dictionary = page_story_dict[index]
		if dict.has("content"):
			page_queue.append(dict["content"])
		time_queue.append(dict["time"])
		append_animation(dict["type"])
	is_animation_loaded = true

#设置下一个需要显示的剧情页
func next_page() -> void:
	if not page_queue.is_empty():
		var page = page_queue.pop_front()
		if page is String:
			text.set_text(page)
		elif page is Texture:
			texture.set_texture(page)
	else:
		animation_player.stop()

#向动画队列中添加动画---------------------------------------------------------------
func append_animation(type: String) -> void:
	match type:
		"text":
			animation_queue.append("story_page_animation/text_fade_in")
			animation_queue.append("story_page_animation/page_still")
			animation_queue.append("story_page_animation/text_fade_out")
		"texture":
			animation_queue.append("story_page_animation/texture_fade_in")
			animation_queue.append("story_page_animation/page_still")
			animation_queue.append("story_page_animation/texture_fade_out")
		"still":
			animation_queue.append("story_page_animation/page_still")

#控制静帧长度函数-------------------------------------------------------------------
func change_play_scale() -> void:
	if not time_queue.is_empty():
		animation_player.speed_scale = 1/(time_queue.pop_front())

func reset_play_scale() -> void:
	animation_player.speed_scale = 1.0
#================================================================================
