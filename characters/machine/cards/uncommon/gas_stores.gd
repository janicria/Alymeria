extends Card

const NANO_PLAGUE = preload("res://effects/status/nano_plague.tres")

var base_amount := 4

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var nano_plague := NANO_PLAGUE.duplicate()
	nano_plague.stacks = base_amount
	status_effect.status = nano_plague
	status_effect.execute(targets)
