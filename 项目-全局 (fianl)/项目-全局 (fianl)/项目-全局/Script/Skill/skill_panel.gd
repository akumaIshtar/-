#================================================================================
# 角色技能面板
#================================================================================

class_name SkillPanel

extends Control

#================================================================================
const SKILL_SLOT = preload("res://Scene/Skill/skill_slot.tscn")

@export var p1_name: String
@export var p2_name: String

@onready var player_data: Node = GameData.player_data
@onready var skill_data: Node = GameData.skill_data

@onready var character_name: Label = $H/P/V/H2/CharacterName
@onready var character_change_button: Button = $H/P/V/H2/CharacterChangeButton


@onready var skill_slot_1: SkillSlot = $H/P/V/H/S1/SkillSlot
@onready var skill_slot_2: SkillSlot = $H/P/V/H/S2/SkillSlot
@onready var skill_slot_3: SkillSlot = $H/P/V/H/S3/SkillSlot
@onready var skill_slot_4: SkillSlot = $H/P/V/H/S4/SkillSlot
@onready var skill_name_1: Label = $H/P/V/H/S1/SkillName
@onready var skill_name_2: Label = $H/P/V/H/S2/SkillName
@onready var skill_name_3: Label = $H/P/V/H/S3/SkillName
@onready var skill_name_4: Label = $H/P/V/H/S4/SkillName

@onready var selected_skill_texture: TextureRect = $H/P/V/P/V/H/P/SelectedSkillTexture
@onready var selected_skill_name: Label = $H/P/V/P/V/H/SelectedSkillName
@onready var selected_skill_info: Label = $H/P/V/P/V/SelectedSkillInfo
@onready var equip_button: Button = $H/P/V/P/V/H/EquipButton
@onready var skill_array: GridContainer = $H/GraphEdit/SkillArray


var selected_skill: Skill:
	set(s):
		if s:
			selected_skill_name.set_text(s.name)
			selected_skill_texture.texture = s.icon
			selected_skill_info.text = s.get_info()
			equip_button.text = "卸下" if s.equipped_index >= 0 else "装备"
			equip_button.visible = true
		else:
			selected_skill_name.set_text("")
			selected_skill_texture.texture = null
			selected_skill_info.text = ""
			equip_button.text = ""
			equip_button.visible = false
		selected_skill = s

var skills: Dictionary
var skill_slots: Array
var skill_holder: String
var is_on_eqiup: bool

#================================================================================
func _ready() -> void:
	skills = {
		0:{
			"slot": skill_slot_1,
			"name": skill_name_1,
		},
		1:{
			"slot": skill_slot_2,
			"name": skill_name_2,
		},
		2:{
			"slot": skill_slot_3,
			"name": skill_name_3,
		},
		3:{
			"slot": skill_slot_4,
			"name": skill_name_4,
		},
	}
	
	connect_to_selected(skill_slot_1)
	connect_to_selected(skill_slot_2)
	connect_to_selected(skill_slot_3)
	connect_to_selected(skill_slot_4)
	
	load_skills("P1")

func connect_to_selected(ss: SkillSlot) -> void:
	ss.selected.connect(select_block)

func connect_to_equipped(ss: SkillSlot) -> void:
	ss.equipped.connect(equip_skill)

func disconnect_to_equipped(ss: SkillSlot) -> void:
	ss.equipped.disconnect(equip_skill)

#================================================================================
#加载技能
func load_skills(holder: String) -> void:
	#加载已装备技能
	skill_holder = holder
	match holder:
		"P1":
			character_name.text = p1_name
			character_change_button.text = "切换为辅助角色"
			set_skill(0, player_data.skill_1)
			set_skill(1, player_data.skill_2)
			set_skill(2, player_data.skill_3)
			set_skill(3, player_data.skill_4)
		"P2":
			character_name.text = p2_name
			character_change_button.text = "切换为主控角色"
			set_skill(0, player_data.skill_5)
			set_skill(1, player_data.skill_6)
			set_skill(2, player_data.skill_7)
			set_skill(3, player_data.skill_8)
	
	#加载备选技能
	for s in skill_array.get_children():
		s.queue_free()
	for s in skill_data.unlocked_skills:
		if skill_data.skill_resources[s].holder == holder:
			var ss := SKILL_SLOT.instantiate()
			ss.set_skill(skill_data.skill_resources[s])
			ss.selected.connect(select_block)
			skill_array.add_child(ss)

#设置技能
func set_skill(index: int, s: Skill) -> void:
	if s:
		skills[index]["name"].set_text(s.name)
		skills[index]["slot"].set_skill(s)
	else:
		skills[index]["name"].set_text("")
		skills[index]["slot"].set_skill(null)

#保存技能
func save_skills() -> void:
	if skill_holder == "P1":
		player_data.skill_1 = skill_slot_1.skill
		player_data.skill_2 = skill_slot_2.skill
		player_data.skill_3 = skill_slot_3.skill
		player_data.skill_4 = skill_slot_4.skill
	elif skill_holder == "P2":
		player_data.skill_5 = skill_slot_1.skill
		player_data.skill_6 = skill_slot_2.skill
		player_data.skill_7 = skill_slot_3.skill
		player_data.skill_8 = skill_slot_4.skill
	else:
		print_debug("Skill save warning.")

#================================================================================
#选择技能部分
func select_block(s: Skill) -> void:
	if s:
		selected_skill = s

func _on_equip_button_pressed():
	if selected_skill.equipped_index == -1:
		equip_start()
	else:
		set_skill(selected_skill.equipped_index, null)
		selected_skill.equipped_index = -1
		selected_skill = null

#开始设置技能前连接信号
func equip_start() -> void:
	connect_to_equipped(skill_slot_1)
	connect_to_equipped(skill_slot_2)
	connect_to_equipped(skill_slot_3)
	connect_to_equipped(skill_slot_4)
	skill_slot_1.set_mouse_texture_visiblility(true)
	skill_slot_2.set_mouse_texture_visiblility(true)
	skill_slot_3.set_mouse_texture_visiblility(true)
	skill_slot_4.set_mouse_texture_visiblility(true)
	is_on_eqiup = true

#结束设置技能后断开信号
func equip_end() -> void:
	is_on_eqiup = false
	disconnect_to_equipped(skill_slot_1)
	disconnect_to_equipped(skill_slot_2)
	disconnect_to_equipped(skill_slot_3)
	disconnect_to_equipped(skill_slot_4)
	skill_slot_1.set_mouse_texture_visiblility(false)
	skill_slot_2.set_mouse_texture_visiblility(false)
	skill_slot_3.set_mouse_texture_visiblility(false)
	skill_slot_4.set_mouse_texture_visiblility(false)
	selected_skill = null

func equip_skill(ss: SkillSlot) -> void:
	if ss.slot_id >= 0:
		set_skill(ss.slot_id, selected_skill)
		selected_skill.equipped_index = ss.slot_id
	equip_end()
#================================================================================

func _on_character_change_button_pressed() -> void:
	if is_on_eqiup:
		equip_end()
	selected_skill = null
	save_skills()
	skill_holder = "P1" if skill_holder == "P2" else "P2"
	load_skills(skill_holder)

func _on_tree_exiting():
	save_skills()

#================================================================================
