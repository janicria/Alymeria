extends Card


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	if targets[0].status_handler._has_status("nano_plague"):
		damage_effect.amount = targets[0].status_handler._get_status("nano_plague").stacks
	else: damage_effect.amount = 0
	damage_effect.sound = sound
	damage_effect.execute(targets)
