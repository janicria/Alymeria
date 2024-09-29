extends Card


func apply_effects(targets: Array[Node]) -> void:
	for i in repeats:
		var damage_effect := DamageEffect.new()
		damage_effect.amount = 4
		damage_effect.sound = sound
		# Timer is so both effects don't apply at once
		await GameManager.get_tree().create_timer(0.1).timeout
		# Prevents card from attacking enemies during their death 
		# animation (copy for all chaotic cards with repeat)
		targets.clear()
		var enemies := GameManager.get_tree().get_nodes_in_group("enemies")
		for enemy: Enemy in enemies: if enemy.is_alive: targets.append(enemy)
		damage_effect.execute([targets.pick_random()])
