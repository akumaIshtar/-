extends Skill

func execute(caster: Node) -> void:
	super.execute(caster)
	var player_data: Node = GameData.player_data
	player_data.m_damage = 2
	caster.creat_bullet(0,40,3,true)
	player_data.Shield = 30
	reset_cooldown()
	caster.is_skill_state = 0
	await  caster.time_counter(5)
	player_data.Shield = 0
	

	
