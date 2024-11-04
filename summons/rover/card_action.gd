extends SummonAction


func apply_effects(target: Node) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = get_modified_damage(1, target)
	damage_effect.sound = sound
	damage_effect.execute([target])
