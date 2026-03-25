@tool
extends BTCooldown

func _setup() -> void:
	duration = blackboard.get_var(BBName.cooldown_duration)
