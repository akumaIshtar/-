extends Skill
func execute(caster: Node) -> void:
	super.execute(caster)
	var player_data: Node = GameData.player_data
	if Input.is_action_just_released(caster.power_press)||caster.charge_time > 3:
		player_data.m_damage = 50 + caster.charge_time * 33
	reset_cooldown()
	await  caster.time_counter(5)	
