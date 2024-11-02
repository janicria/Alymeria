extends Status

const NANO_PLAGUE = preload("res://effects/status/nano_plague.tres")


func initalise_target(target: Node) -> void:
	Events.player_card_played.connect(card_played.bind(target))


# Used to throw away card from player_card_played
func card_played(_card: Card, target: Node) -> void:
	apply_status(target)


func apply_status(target: Node) -> void:
	var status_effect := StatusEffect.new()
	var nano_plague := NANO_PLAGUE.duplicate()
	nano_plague.stacks = 1
	status_effect.status = nano_plague
	status_effect.execute([target])
	status_effect.execute(target.get_tree().get_nodes_in_group("enemies"))
