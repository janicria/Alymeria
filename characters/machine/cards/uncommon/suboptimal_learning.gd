extends Card

const SUBOPTIMAL := preload("res://effects/status/suboptimal.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var suboptimal := SUBOPTIMAL.duplicate()
	suboptimal.stacks = 1
	status_effect.status = suboptimal
	status_effect.execute(targets)
