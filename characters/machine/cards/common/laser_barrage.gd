extends Card

var base_damage := 4


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	for i in repeats:
		var damage_effect := DamageEffect.new()
		damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
		damage_effect.sound = sound
		
		# Timer is so both effects don't apply at once
		await Data.get_tree().create_timer(0.1).timeout
		
		# Prevents card from attacking enemies during their death 
		# animation (copy for all chaotic cards with repeat)
		targets.clear()
		var enemies := Data.get_tree().get_nodes_in_group("enemies")
		for enemy: Enemy in enemies: if enemy.is_alive: targets.append(enemy)
		# In case all enemies died from the first attack
		if targets.is_empty(): return
		damage_effect.execute([targets.pick_random()])


func get_tooltip_text(player_mods: ModifierHandler, enemy_mods: ModifierHandler) -> String:
	if !player_mods: return tooltip_text % base_damage # When not in a battle
	var modified_dmg := player_mods.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	if enemy_mods: modified_dmg = enemy_mods.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
	return tooltip_text % modified_dmg
