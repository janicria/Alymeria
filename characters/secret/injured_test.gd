extends Card

const INJURED := preload("res://effects/status/injured.tres")


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var injured := INJURED.duplicate()
	injured.duration = 3
	status_effect.status = injured
	status_effect.execute(targets)
	
