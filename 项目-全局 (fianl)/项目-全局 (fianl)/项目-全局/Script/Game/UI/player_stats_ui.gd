#================================================================================
# 记录角色数据的节点
#================================================================================

extends Control

#================================================================================
@onready var player_data: Node = GameData.player_data
@onready var hp_bar: TextureProgressBar = $P/V/HP_Bar
@onready var mp_bar: TextureProgressBar = $P/V/H/MP_bar
@onready var sp_bar: TextureProgressBar = $P/V/H/SP_Bar

@onready var sanity_bar = $P/V/SanityBar

@onready var texture_1 = $P/V/H/H/Skill1/P/Texture
@onready var texture_2 = $P/V/H/H/Skill2/P/Texture
@onready var texture_3 = $P/V/H/H/Skill3/P/Texture
@onready var texture_4 = $P/V/H/H/Skill4/P/Texture

var skill_holder: String = "P1"

#================================================================================

#初始化加载函数
func _ready() -> void:
	#连接生命改变的信号
	player_data.max_hp_changed.connect(update_max_hp)
	player_data.hp_changed.connect(update_hp)
	#连接蓝亮改变的信号
	player_data.max_mp_changed.connect(update_max_mp)
	player_data.mp_changed.connect(update_mp)
	#连接魂值改变的信号
	player_data.max_sp_changed.connect(update_max_sp)
	player_data.sp_changed.connect(update_sp)
	#连接技能改变信号
	player_data.skill_changed.connect(update_skill)
	player_data.sanity_changed.connect(update_sanity)
	player_data.update_skill_request("P1")

func _process(delta) -> void:
	update_skill_cooldown()


#================================================================================
#更新血条函数
func update_max_hp(value: int) -> void:
	hp_bar.max_value = value
func update_hp(value: int) -> void:
	hp_bar.value = value

#更新蓝条函数
func update_max_mp(value: int) -> void:
	mp_bar.max_value = value
func update_mp(value: int) -> void:
	mp_bar.value = value

#更新魂值函数
func update_max_sp(value: int) -> void:
	sp_bar.max_value = value
func update_sp(value: int) -> void:
	sp_bar.value = value

#更新理智值函数
func update_sanity(value: int) -> void:
	sanity_bar.value = value

#================================================================================
#技能部分
var skill_1_progress: float:
	set(v):
		if skill_1_progress and not v:
			skill_flash(0)
		texture_1.material.set_shader_parameter("progress", v)
		skill_1_progress = v
var skill_2_progress: float:
	set(v):
		if skill_2_progress and not v:
			skill_flash(1)
		texture_2.material.set_shader_parameter("progress", v)
		skill_2_progress = v
var skill_3_progress: float:
	set(v):
		if skill_3_progress and not v:
			skill_flash(2)
		texture_3.material.set_shader_parameter("progress", v)
		skill_3_progress = v
var skill_4_progress: float:
	set(v):
		if skill_4_progress and not v:
			skill_flash(3)
		texture_4.material.set_shader_parameter("progress", v)
		skill_4_progress = v

#更新技能图标 
func update_skill(index: int, texture) -> void:
	match index:
		0:
			texture_1.texture = texture
		1:
			texture_2.texture = texture
		2:
			texture_3.texture = texture
		3:
			texture_4.texture = texture

func update_skill_cooldown() -> void:
	match skill_holder:
		"P1":
			if player_data.skill_1:
				skill_1_progress = player_data.skill_1.get_progress()
			if player_data.skill_2:
				skill_2_progress = player_data.skill_2.get_progress()
			if player_data.skill_3:
				skill_3_progress = player_data.skill_3.get_progress()
			if player_data.skill_4:
				skill_4_progress = player_data.skill_4.get_progress()
		"P2":
			if player_data.skill_5:
				skill_1_progress = player_data.skill_5.get_progress()
			if player_data.skill_6:
				skill_2_progress = player_data.skill_6.get_progress()
			if player_data.skill_7:
				skill_3_progress = player_data.skill_7.get_progress()
			if player_data.skill_8:
				skill_4_progress = player_data.skill_8.get_progress()

#技能闪烁
func skill_flash(index: int) -> void:
	var tween: Tween = get_tree().create_tween()
	match index:
		0:
			tween.tween_property(texture_1.material, "shader_parameter/flash_progress", 1, 0.1)
			tween.tween_property(texture_1.material, "shader_parameter/flash_progress", 0, 0.1)
		1:
			tween.tween_property(texture_2.material, "shader_parameter/flash_progress", 1, 0.1)
			tween.tween_property(texture_2.material, "shader_parameter/flash_progress", 0, 0.1)
		2:
			tween.tween_property(texture_3.material, "shader_parameter/flash_progress", 1, 0.1)
			tween.tween_property(texture_3.material, "shader_parameter/flash_progress", 0, 0.1)
		3:
			tween.tween_property(texture_4.material, "shader_parameter/flash_progress", 1, 0.1)
			tween.tween_property(texture_4.material, "shader_parameter/flash_progress", 0, 0.1)
#================================================================================
 
func change_to_1() -> void:
	player_data.update_skill_request("P1")
	skill_holder = "P1"

func change_to_2() -> void:
	player_data.update_skill_request("P2")
	skill_holder = "P2"

#================================================================================

func _unhandled_input(event):
	if event.is_action_pressed("advance"):
		change_to_2()
	if event.is_action_released("advance"):
		change_to_1()
