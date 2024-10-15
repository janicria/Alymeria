extends EnemyCard

const DEFENCE_UP = preload("res://effects/status/defence_up.tres")

func custom_play(final_targets: Array[Node]) -> void:
	var status_effect := StatusEffect.new()
	var defence_up := DEFENCE_UP.duplicate()
	defence_up.stacks = 2
	status_effect.status = defence_up
	status_effect.execute(final_targets)
