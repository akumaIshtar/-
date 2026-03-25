#================================================================================
# 技能树
#================================================================================

extends Node2D

#================================================================================

@export var skill_tree_data: Resource

@onready var skill_data: Node = GameData.skill_data
@onready var player_data: Node = GameData.player_data

@onready var nodes: Node = $Nodes
@onready var lines: CanvasGroup = $Lines
@onready var left_point_label: Label = $CanvasLayer/LeftPointLabel

@onready var skill_info_panel: PanelContainer = $CanvasLayer/SkillInfoPanel
@onready var skill_name: Label = $CanvasLayer/SkillInfoPanel/V/SkillName
@onready var skill_description: Label = $CanvasLayer/SkillInfoPanel/V/SkillDescription
@onready var unlock_button: Button = $CanvasLayer/SkillInfoPanel/V/UnlockButton

var unlocked_nodes: Array[String] = []
var skill_point: int:
	set(v):
		left_point_label.set_text("剩余技能点数: " + str(v))
		skill_data.skill_point = v
		skill_point = v
var selected_node: SkillTreeNode:
	set(v):
		set_selected_info(v)
		selected_node = v
#================================================================================

func _ready():
	skill_tree_data = skill_data.skill_tree_data
	unlocked_nodes = skill_data.unlocked_nodes
	skill_point = skill_data.skill_point
	generate_skill_tree()

func generate_skill_tree():
	# 生成所有技能节点
	for node_id in skill_tree_data.nodes:
		var node_data = skill_tree_data.nodes[node_id]
		if node_data["type"] == "Skill":
			var node = preload("res://Scene/Skill/skill_node.tscn").instantiate()
			node.node_id = node_id
			node.position = node_data.position
			node.selected.connect(select_node)
			node.init_node.call_deferred(skill_data.skill_resources.get(node_id))
			node.node_data = node_data
			nodes.add_child.call_deferred(node)
		
		elif node_data["type"] == "Attribute":
			var node = preload("res://Scene/Skill/attribute_node.tscn").instantiate()
			node.node_id = node_id
			node.position = node_data.position
			node.selected.connect(select_node)
			node.init_node.call_deferred(node_data["info"])
			node.node_data = node_data
			nodes.add_child.call_deferred(node)
	
	update_nodes_state.call_deferred()
	
	# 绘制连接线
	_draw_connections.call_deferred()

# 绘制节点间的连线
func _draw_connections():
	#connections.clear_points()
	for node in nodes.get_children():
		for req_id in node.node_data["required"]:
			var start_pos = skill_tree_data.nodes[req_id].position
			var end_pos = node.position
			var line = Line2D.new()
			line.add_point(start_pos)
			line.add_point(end_pos)
			
			line.width_curve = get_meta("LineCurve")
			line.gradient = get_meta("LineGradient2")
			#line.material = get_meta("LineShader")
			
			lines.add_child(line)

#================================================================================
# 更新选中节点信息
func update_selected_node() -> void:
	set_selected_info(selected_node)
	if selected_node is SkillNode:
		selected_node.set_node(selected_node.skill, Color.GOLD)
	else:
		selected_node.set_node(skill_tree_data.nodes[selected_node.node_id]["info"])
	
	update_nodes_state()
	
	for line in lines.get_children():
		if skill_tree_data.nodes[selected_node.node_id].position in line.points:
			line.gradient = get_meta("LineGradient1")

func update_nodes_state() -> void:
	for node in nodes.get_children():
		if skill_tree_data.nodes[node.node_id]["unlocked"]:
			node.set_state(1)
		elif _check_requirements(node.node_id):
			node.set_state(2)
		else:
			node.set_state(0)

func select_node(n: SkillTreeNode) -> void:
	selected_node = n

# 显示选中技能信息
func set_selected_info(n: SkillTreeNode) -> void:
	skill_info_panel.visible = true
	if n is SkillNode:
		skill_name.set_text(n.skill.name)
		skill_description.set_text(n.skill.get_info())
	elif n is AttributeNode:
		skill_name.set_text(n.attribute["name"])
		skill_description.set_text(n.get_info())
		
	var text: String = ""
	if skill_tree_data.nodes[n.node_id]["unlocked"]:
		text = "已解锁"
		unlock_button.disabled = true
	elif _check_requirements(n.node_id):
		var cost: int = skill_tree_data.nodes[n.node_id]["cost"]
		text = "消耗 " + str(cost) + " 技能点以解锁"
		if skill_point < cost:
			unlock_button.disabled = true
		else:
			unlock_button.disabled = false
	else:
		text = "条件不足"
		unlock_button.disabled = true
	unlock_button.set_text(text)

func _check_requirements(node_id: String) -> bool:
	if skill_tree_data.nodes[node_id].required.is_empty():
		return true
	for req_id in skill_tree_data.nodes[node_id].required:
		if req_id in unlocked_nodes:
			return true
	return false

func _on_unlock_button_pressed() -> void:
	skill_point -= skill_tree_data.nodes[selected_node.node_id]["cost"]
	skill_tree_data.nodes[selected_node.node_id]["unlocked"] = true
	unlocked_nodes.append(selected_node.node_id)
	
	if selected_node is SkillNode:
		skill_data.unlock_skill(selected_node.skill.id)
	if selected_node is AttributeNode:
		player_data.add_attribute(selected_node.attribute["attribute"])
	update_selected_node()
#================================================================================

func _on_tree_exiting():
	skill_data.skill_tree_data = skill_tree_data
	skill_data.unlocked_nodes = unlocked_nodes

#================================================================================
