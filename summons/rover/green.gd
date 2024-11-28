extends SummonAction


func setup() -> void:
	Events.update_battle_state.connect(
		func(state: Battle.State) -> void:
			if state == Battle.State.ENEMY_DRAW:
				stats.action_played(self)
				Data.player_handler.draw_card()
	)
