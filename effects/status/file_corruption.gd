class_name FileCorruption
extends Status

const NANO_PLAGUE = preload("res://effects/status/nano_plague.tres")


func initalise_target(target: Node) -> void:
	Events.player_card_played.connect(apply_status.bind(target))


func apply_status(target: Node) -> void:
	var status_effect := StatusEffect.new()
	var nano_plague := NANO_PLAGUE.duplicate()
	nano_plague.stacks = 1
	status_effect.status = nano_plague
	status_effect.execute([target])
	status_effect.execute(target.get_tree().get_nodes_in_group("enemies"))
