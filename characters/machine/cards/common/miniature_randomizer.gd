extends Card

const BUFFS: Array[Status] = [preload("res://effects/status/damage_up.tres"), preload("res://effects/status/defence_up.tres")]
const DEBUFFS: Array[Status] = [preload("res://effects/status/injured.tres"), preload("res://effects/status/nano_plague.tres")]


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	status_effect.status = BUFFS.pick_random() if randi_range(0, 1) else DEBUFFS.pick_random()
	status_effect.execute(targets)
	if BUFFS.has(status_effect.status):
		status_effect.status = BUFFS.pick_random()
		status_effect.execute(targets)
