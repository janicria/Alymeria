extends SummonAction


func setup() -> void:
	if !Events.card_exhausted.is_connected(apply_effects):
		Events.card_exhausted.connect(apply_effects)


func apply_effects(_target: Node) -> void:
	stats.action_played(self)
	Data.player_handler.player.stats.heal(1)
