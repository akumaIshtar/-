extends Skill
func execute(caster: Node) -> void:
	super.execute(caster)
	var player_data: Node = GameData.player_data
	player_data.h_is_skill_damage = true
	player_data.s_damage = 30
	player_data.h_is_skill_damage = true
	caster.creat_bullet()
	reset_cooldown()
	await  caster.player.time_counter(5)
