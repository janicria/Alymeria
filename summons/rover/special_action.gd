extends SummonAction

const DEFENCE_UP = preload("res://effects/status/defence_up.tres")


func apply_effects(target: Node) -> void:
	var status_effect := StatusEffect.new()
	status_effect.status = DEFENCE_UP
	status_effect.execute([target])
