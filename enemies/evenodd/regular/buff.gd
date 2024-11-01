extends EnemyCard

const DAMAGE_UP = preload("res://effects/status/damage_up.tres")

func custom_play(final_targets: Array[Node]) -> void:
	var status_effect := StatusEffect.new()
	var damage_up := DAMAGE_UP.duplicate()
	damage_up.stacks = 2
	status_effect.status = damage_up
	status_effect.execute(final_targets)
