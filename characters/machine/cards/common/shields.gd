extends Card

var base_barrier := 4


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var barrier_effect := BarrierEffect.new()
	barrier_effect.amount = modifiers.get_modified_value(base_barrier, Modifier.Type.BARRIER_GAINED)
	barrier_effect.sound = sound
	barrier_effect.execute(targets)


func get_tooltip_text(player_mods: ModifierHandler, _enemy_mods: ModifierHandler) -> String:
	if !player_mods: return tooltip_text % base_barrier # When not in a battle
	var modified_dmg := player_mods.get_modified_value(base_barrier, Modifier.Type.BARRIER_GAINED)
	return tooltip_text % modified_dmg
