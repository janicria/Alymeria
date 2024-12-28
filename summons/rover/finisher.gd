extends SummonAction


func apply_effects(target: Node) -> void:
# Organic computing
	if Data.battle.state == Battle.State.BASE:
		await Data.enemy_handler.finished_drawing
	
	stats.summon.take_damage(Data.player_handler.player.modifier_handler.get_modified_value(
		stats.health / 2, Modifier.Type.DMG_DEALT))
	
	await stats.summon.damaged
	
	target.call("take_damage", Data.player_handler.player.modifier_handler.get_modified_value(
		stats.health / 3, Modifier.Type.DMG_DEALT))
