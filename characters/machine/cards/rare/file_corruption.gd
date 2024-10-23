extends Card

const FILE_CORRUPTION = preload("res://effects/status/file_corruption.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var file_corruption := FILE_CORRUPTION.duplicate()
	file_corruption.stacks = 1
	status_effect.status = file_corruption
	status_effect.execute(targets)
	# New edits on file corruption status prevent played this card 
	# from applying nano after being played, so we need to do it again here
	file_corruption.apply_status(targets[0])
