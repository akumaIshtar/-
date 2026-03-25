extends Skill
func execute(caster: Node) -> void:
	super.execute(caster)
	var player_data: Node = GameData.player_data
	player_data.m_damage = 80
	caster.creat_bullet(800,60,1,false)
	reset_cooldown()
	caster.is_skill_state = 0
	await  caster.time_counter(10)
	
	
