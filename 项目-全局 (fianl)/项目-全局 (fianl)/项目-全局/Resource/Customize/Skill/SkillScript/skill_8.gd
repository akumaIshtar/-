extends Skill
func execute(caster: Node) -> void:
	super.execute(caster)
	var player_data: Node = GameData.player_data
	player_data.hp += 30
	caster.player.anim_s.visible = true
	caster.player.anim_s.play("yu")
	await  caster.player.time_counter(1.2)
	caster.player.anim_s.visible = false
	reset_cooldown()
	await  caster.player.time_counter(5)
