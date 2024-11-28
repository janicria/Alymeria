extends SummonAction


func setup() -> void:
	Events.card_exhausted.connect(
		func() -> void:
			stats.action_played(self)
			Data.player_handler.player.stats.heal(1)
	)
