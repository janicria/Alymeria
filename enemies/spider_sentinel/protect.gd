extends EnemyCard


func custom_play(final_targets: Array[Node]) -> void:
	for enemy: Enemy in final_targets:
		if enemy.stats.name != "Spider Sentinel":
			var barrier_effect := BarrierEffect.new()
			barrier_effect.amount = cardui.enemy_stats.modifier_handler.get_modified_value(4, Modifier.Type.BARRIER_GAINED)
			barrier_effect.sound = SFX_dict.get(type)
			barrier_effect.execute([enemy])
