class_name NanoPlague
extends Status

const NANO_PLAGUE = preload("res://effects/status/nano_plague.tres")

func apply_status(target: Node) -> void:
	target.take_damage(ceili(stacks / 2))
	var status_effect := StatusEffect.new()
	var nano_plauge := NANO_PLAGUE.duplicate()
	status_effect.status = nano_plauge
	status_effect.execute(target.get_tree().get_nodes_in_group(target.get_groups()[-1]))
