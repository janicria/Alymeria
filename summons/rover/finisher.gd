extends SummonAction


func apply_effects(target: Node) -> void:
# Organic computing
	if Data.battle.state == Battle.State.BASE:
		await Data.enemy_handler.finished_drawing
	
	target.call("take_damage", get_modified_damage(
		stats.health, Data.player_handler.player.modifier_handler, target), false)
	stats.health = ceil(stats.health / 2)
