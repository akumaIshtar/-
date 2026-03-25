extends Resource

@export var dialogue_lib: Dictionary = {}

func add_dialogue_to_lib(dialogue_name: String, dialogue) -> void:
	dialogue_lib[dialogue_name] = dialogue
