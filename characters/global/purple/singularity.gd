extends Card

var base_damage := 50


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)


func cached() -> void:
	cost -= 1


func get_tooltip_text(player_mods: ModifierHandler, enemy_mods: ModifierHandler) -> String:
	if !player_mods: return tooltip_text % base_damage # When not in a battle
	var modified_dmg := player_mods.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	if enemy_mods: modified_dmg = enemy_mods.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
	return tooltip_text % modified_dmg
