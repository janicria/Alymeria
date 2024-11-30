extends SummonAction


func setup() -> void:
	if !Events.update_battle_state.is_connected(state_check):
		Events.update_battle_state.connect(state_check)


func state_check(state: Battle.State) -> void:
	if state == Battle.State.ENEMY_DRAW:
		stats.action_played(self)
		Data.player_handler.draw_card()


func apply_effects(_target: Node) -> void:
	stats.action_played(self)
	Data.player_handler.draw_card()
