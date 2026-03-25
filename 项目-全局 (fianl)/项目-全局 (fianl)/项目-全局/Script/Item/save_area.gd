extends Area2D

@onready var game_data: Node = GameData

var is_saved: bool = false

func _on_body_entered(body) -> void:
	if body is Player:
		if not is_saved:
			game_data.save_game()
			is_saved = true
