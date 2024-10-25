extends Core


func activate() -> void:
	var enemies := Data.get_tree().get_nodes_in_group("enemies")
	for enemy: Enemy in enemies:
		if slotted: enemy.take_damage(
			enemy.modifier_handler.get_modified_value(8, Modifier.Type.DMG_DEALT))
		else: enemy.take_damage(5)
