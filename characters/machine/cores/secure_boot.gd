extends Core

const EXHAUST = preload("res://effects/card_status/exhaust.tres")


func activate() -> void:
	# In case core was removed
	if coreui == null: return
	coreui.flash()
	
	Data.player_handler.draw_card()
	await Events.player_hand_drawn
	coreui.flash()
	Data.battle_ui.custom_pile_view.card_pile = CardPileView.generate_cardpile_from_ui(
		Data.battle_ui.hand.get_children())
	Data.battle_ui.custom_pile_view.show_current_view("Select a card to give exhaust")
	await Data.get_tree().process_frame
	Data.battle_ui.custom_pile_view.select_card()
	Data.battle_ui.custom_pile_view.card_selected.connect(func(card:Card)->void:
		card.add_status(EXHAUST.duplicate())
		card.cardui.set_card(card)
		Data.battle_ui.custom_pile_view._hide())
