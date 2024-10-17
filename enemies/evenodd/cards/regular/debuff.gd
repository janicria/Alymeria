extends EnemyCard

const INJURED = preload("res://effects/status/injured.tres")

func custom_play(final_targets: Array[Node]) -> void:
	var status_effect := StatusEffect.new()
	var injured := INJURED.duplicate()
	injured.duration = 2
	status_effect.status = injured
	status_effect.execute(final_targets)
