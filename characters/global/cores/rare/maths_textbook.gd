extends Core


func added() -> void:
	Events.update_battle_state.connect(battle_state_updated)
	Events.player_card_played.connect(card_played)


func battle_state_updated(state: Battle.State) -> void:
	if state != Battle.State.PLAYER: return
	Data.character.mana += 1
	await Events.player_hand_drawn
	await coreui.get_tree().create_timer(0.1).timeout
	if coreui.slotted: Data.player_handler.draw_card()


func card_played(_card: Card) -> void:
	Data.player_handler.draw_card()
	# TODO: Allow player to choose card
	Data.player_handler.hand.toggle_hand_state(true)
	await coreui.get_tree().create_timer(0.5).timeout
	Data.player_handler.hand.toggle_hand_state(false)
	Data.player_handler.hand.discard_card(Data.player_handler.hand.get_children().pick_random())
