extends Skill
func execute(caster: Node) -> void:
	super.execute(caster)
	var player_data: Node = GameData.player_data
	player_data.s_damage = 25
	player_data.h_is_skill_damage = true
	caster.global_position = caster.camera.get_screen_center_position()
	caster.ex_skill.visible = true
	caster.ex_skill.play("ex")
	caster.is_combo(10,caster.attack_all)
	await caster.player.time_counter(2.5)
	caster.ex_skill.visible = false
	caster.global_position = caster.get_parent().global_position + Vector2(-64, -150)
	reset_cooldown()
	await  caster.player.time_counter(5)
