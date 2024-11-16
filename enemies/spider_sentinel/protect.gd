extends EnemyCard


func custom_play(final_targets: Array[Node]) -> void:
	var highest_health := [0, Enemy]
	for enemy: Enemy in final_targets:
		if enemy.stats.health > highest_health[0]:
			highest_health[0] = enemy.stats.health
			highest_health[1] = enemy
		if enemy.stats.name != "Spider Sentinel":
			var barrier_effect := BarrierEffect.new()
			barrier_effect.amount = cardui.enemy_stats.modifier_handler.get_modified_value(4, Modifier.Type.BARRIER_GAINED)
			barrier_effect.sound = SFX_dict.get(type)
			barrier_effect.execute([enemy])
	highest_health[1].mana += 1
