extends Card

const FILE_CORRUPTION = preload("res://effects/status/file_corruption.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var file_corruption := FILE_CORRUPTION.duplicate()
	file_corruption.stacks = 1
	status_effect.status = file_corruption
	status_effect.execute(targets)
