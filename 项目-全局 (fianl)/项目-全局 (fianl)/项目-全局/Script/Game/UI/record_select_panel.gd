#================================================================================
# 存档选择面板
#================================================================================

extends Control

#================================================================================

@onready var game_data: Node = GameData

@onready var button_1: Button = $P/M/V/H/P1/V1/Button1
@onready var button_2: Button = $P/M/V/H/P2/V2/Button2
@onready var button_3: Button = $P/M/V/H/P3/V3/Button3

@onready var record_info_1: Label = $P/M/V/H/P1/V1/RecordInfo1
@onready var record_info_2: Label = $P/M/V/H/P2/V2/RecordInfo2
@onready var record_info_3: Label = $P/M/V/H/P3/V3/RecordInfo3

#================================================================================

func _ready() -> void:
	load_record_information()

func load_record_information() -> void:
	await game_data.load_record_data()
	
	var records: Dictionary = game_data.record_dict
	for id in records:
		if records[id]:
			print(records[id])
			var text: String = ""
			text += records[id]["place"] + '\n'
			text += records[id]["time"]
			set_record_label(id, text)
		else:
			set_record_label(id, "无")

func _on_record_button_pressed(id: int) -> void:
	game_data.selected_record_id = id
	game_data.start_game_from_record(id)

func set_record_label(label_id: int, text: String) -> void:
	match label_id:
		1: record_info_1.set_text(text)
		2: record_info_2.set_text(text)
		3: record_info_3.set_text(text)

func _on_back_button_pressed():
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

#================================================================================
