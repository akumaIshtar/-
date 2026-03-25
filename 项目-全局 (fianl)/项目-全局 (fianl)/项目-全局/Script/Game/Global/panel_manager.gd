#===================================================================================================
# 面板管理
#===================================================================================================
extends Node
#===================================================================================================
var UI_LAYER: CanvasLayer # 使用CanvasLayer确保UI独立于游戏场景

const PANELS: = {
	"skill": {
		"scene": preload("res://Scene/Skill/skill_panel.tscn"),
		"action": "tab"
	},
	"skill_tree": {
		"scene": preload("res://Scene/Skill/skill_tree_panel.tscn"),
		"action": "debug"
	},
}# 配置数据结构化

const EXIT_PANEL: = preload("res://Scene/Game/UI/option_panel.tscn") # 退出面板（这一部分应该有bug）

signal panel_toggled(panel_id, is_open)
signal exit_panel_requested

var active_panels: = {}  # 使用字典存储面板实例 {panel_id: instance}


var exit_panel: Control = null
#===================================================================================================
# 初始化面板图层
func _ready():
	UI_LAYER = CanvasLayer.new()
	UI_LAYER.layer = 128  # 确保在最上层
	add_child(UI_LAYER)

# 接收键盘输入
func _unhandled_input(event):
	if event.is_action_pressed("esc"):
		_handle_escape()
		get_viewport().set_input_as_handled()
		return
	
	for panel_id in PANELS:
		if event.is_action_pressed(PANELS[panel_id].action):
			toggle_panel(panel_id)
			get_viewport().set_input_as_handled()
			break

# 面板开关
func toggle_panel(panel_id: String):
	if panel_id in active_panels:
		print("this panel has been here")
		close_panel(panel_id)
	else:
		open_panel(panel_id)

# 打开面板
func open_panel(panel_id: String):
	if panel_id in active_panels:
		return
	
	var panel_config = PANELS.get(panel_id)
	if not panel_config:
		push_error("Invalid panel ID: %s" % panel_id)
		return
	
	var panel_instance = panel_config.scene.instantiate()
	panel_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	if panel_instance is Node2D:
		add_child(panel_instance)
	else:
		UI_LAYER.add_child(panel_instance)
	active_panels[panel_id] = panel_instance
	
	_update_game_pause()
	panel_toggled.emit(panel_id, true)

# 关闭面板
func close_panel(panel_id: String):
	var panel = active_panels.get(panel_id)
	if not panel:
		return
	
	panel.queue_free()
	active_panels.erase(panel_id)
	_update_game_pause()
	panel_toggled.emit(panel_id, false)

# 退出面板开关
func _handle_escape():
	if not active_panels.is_empty():
		close_all_panels()
	else:
		print("active_panels is empty")
		show_exit_panel()

# 关闭所有面板
func close_all_panels():
	for panel_id in active_panels.duplicate():
		close_panel(panel_id)

# 展示退出面板
func show_exit_panel():
	if exit_panel:
		return
	
	exit_panel = EXIT_PANEL.instantiate()
	UI_LAYER.add_child(exit_panel)
	
	# 连接关闭信号
	exit_panel.tree_exited.connect(_on_exit_panel_closed)
	exit_panel_requested.emit()

func _on_exit_panel_closed():
	exit_panel = null

# 时间暂停
func _update_game_pause():
	get_tree().paused = not active_panels.is_empty()
