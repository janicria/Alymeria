extends Status

const NANO_PLAGUE = preload("res://effects/status/nano_plague.tres")

var active := true

func apply_status(target: Node) -> void:
	if !active: active = true; return
	target.take_damage(ceili(stacks * 0.8))
	var status_effect := StatusEffect.new()
	var nano_plauge := NANO_PLAGUE.duplicate()
	nano_plauge.stacks = ceili(stacks * 0.2)
	status_effect.status = nano_plauge
	nano_plauge.active = false
	for ally in target.get_tree().get_nodes_in_group(target.get_groups()[-1]):
		if ally != target: status_effect.execute([ally])
