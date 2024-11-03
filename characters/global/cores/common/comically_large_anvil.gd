extends Core


func activate() -> void:
	var enemies := Data.get_tree().get_nodes_in_group("enemies")
	for enemy: Enemy in enemies:
		var modified_damage: int = Data.get_tree().get_first_node_in_group("player").modifier_handler.get_modified_value(
			5, Modifier.Type.DMG_DEALT)
		if coreui.slotted: enemy.take_damage(
			enemy.modifier_handler.get_modified_value(modified_damage, Modifier.Type.DMG_DEALT))
		else: enemy.take_damage(2)
