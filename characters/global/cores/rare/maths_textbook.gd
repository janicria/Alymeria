extends Core


func added() -> void:
	Events.player_card_played.connect(card_played)


func activate() -> void:
	Data.character.mana += 1
	await coreui.get_tree().create_timer(0.1).timeout
	if coreui.slotted: Data.player_handler.draw_card()


func card_played(_card: Card) -> void:
	# In case core was removed
	if coreui == null: return
	coreui.flash()
	
	Data.player_handler.draw_card()
	Data.battle_ui.custom_pile_view.card_pile = CardPileView.generate_cardpile_from_ui(
		Data.battle_ui.hand.get_children())
	Data.battle_ui.custom_pile_view.show_current_view("Select a card to discard")
	await Data.get_tree().process_frame
	Data.battle_ui.custom_pile_view.select_card()
	Data.battle_ui.custom_pile_view.card_selected.connect(func(card:Card)->void:
		Data.battle_ui.hand.discard_card(card.cardui)
		Data.battle_ui.custom_pile_view._hide())
