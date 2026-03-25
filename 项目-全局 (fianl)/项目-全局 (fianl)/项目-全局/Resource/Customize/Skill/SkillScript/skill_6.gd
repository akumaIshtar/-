extends Skill
func execute(caster: Node) -> void:
	super.execute(caster)
	var player_data: Node = GameData.player_data
	if caster.enemy:
		player_data.s_damage = 25
		player_data.h_is_skill_damage = true
		caster.global_position.y = caster.enemy.global_position.y - 30
		caster.global_position.x = caster.enemy.global_position.x - 50
		caster.velocity = Vector2.ZERO
		caster.anim_tree["parameters/playback"].travel("attack_skill")
		await caster.player.time_counter(0.8)
		caster.is_combo(5,caster.attack)
		await caster.player.time_counter(1.1)
		caster.global_position = caster.get_parent().global_position + Vector2(-64, -150)
	reset_cooldown()
	await  caster.player.time_counter(5)
