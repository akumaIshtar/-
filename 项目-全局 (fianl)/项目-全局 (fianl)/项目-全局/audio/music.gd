#======================================================================
# 背景音乐音效的管理
# 添加至全局场景后,调用示例：Music.bgm_play("bgm_1"),Music.se_play("se_1")
#======================================================================

extends Node

#======================================================================
const AUDIO_PATHS = {
	# 背景音乐
	"bgm_1":"res://audio/bgm/bgm1.mp3",
	"bgm_2":"res://audio/bgm/bgm2.mp3",
	
	# 音效
	"run":"res://audio/soundeffect/奔跑.mp3",
	"beat1" :"res://audio/soundeffect/打击1.mp3",
	"beat2" :"res://audio/soundeffect/打击2.mp3",
	"beat3" :"res://audio/soundeffect/打击3.mp3",
	"get":"res://audio/soundeffect/拾取.mp3",
	"jump":"res://audio/soundeffect/跳跃.mp3",
	"hurt":"res://audio/soundeffect/受伤.mp3"
}

var bgm_player: AudioStreamPlayer # 背景音乐播放器
var se_players: = [] # 音效播放器

var max_se_amount: int = 10 # 同时存在音效的最大数量
var is_bgm_fading: bool = false
var current_tween: Tween
#=====================================================================
# 初始化全局音乐播放
func _ready() -> void:
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	for i in max_se_amount:
		var player = AudioStreamPlayer2D.new()
		add_child(player)
		se_players.append(player)
		
# 背景音乐播放
func bgm_play(bgm_name: String) -> void:
	if not AUDIO_PATHS.has(bgm_name):
		push_error("音乐库中无音频： %s" % bgm_name)
		return
	if bgm_player.stream != null and bgm_player.stream.resource_path == AUDIO_PATHS[bgm_name]: return
	if ResourceLoader.has_cached(AUDIO_PATHS[bgm_name]): return
	ResourceLoader.load_threaded_request(AUDIO_PATHS[bgm_name])
	var path = AUDIO_PATHS[bgm_name]
	bgm_fade(path)
	

# 背景音乐的淡入淡出
func bgm_fade(bgm_path: String, fade_time: float = 2.0, volume: float = 0.0) -> void:
	if is_bgm_fading: return
	is_bgm_fading = true
	if current_tween && current_tween.is_valid():
		current_tween.kill()
	
	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	var stream = ResourceLoader.load_threaded_get(bgm_path)
	stream.loop = true
	new_player.stream = stream
	new_player.volume_db = -80.0
	new_player.play()
	current_tween = create_tween().set_parallel(true)
	current_tween.tween_property(bgm_player, "volume_db", -80.0, fade_time)
	current_tween.tween_property(new_player, "volume_db", volume, fade_time)
	await current_tween.finished
	
	bgm_player.queue_free()
	bgm_player = new_player
	is_bgm_fading = false

# 音效播放
func se_play(se_name: String) -> void:
	if not AUDIO_PATHS.has(se_name):
		push_error("音乐库中无音频： %s" % se_name)
		return
	var player = get_available_player()
	if not player: return
	var config = AUDIO_PATHS.get(se_name)
	if not config: return
	player.stream = load(get_audio_path(config))
	player.volume_db = 0.0  
	
	if config is Dictionary:
		if config.get("fade_in", 0.0) > 0:
			player.volume_db = -80.0
			create_tween().tween_property(player, "volume_db", 0.0, config.fade_in)
		player.play()
		player.connect("finished", music_finished.bind(player))
	else:
		player.play()
		player.connect("finished", music_finished.bind(player))

# 检测是否有空的音效播放器
func get_available_player() -> AudioStreamPlayer2D:
	for player in se_players:
		if not player.playing: return player
	return null

# 清理播放器
func music_finished(player: AudioStreamPlayer2D):
	player.disconnect("finished", music_finished)
	player.stop()
	
# 寻找音效路径
func get_audio_path(config) -> String:
	if config is Array: return config.pick_random()
	if config is Dictionary: return config.path
	return config

# 停止所有的音效
func se_stop() -> void:
	for player in se_players:
		player.stop()
