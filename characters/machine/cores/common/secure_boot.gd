extends Core

const EXHAUST = preload("res://effects/card_status/exhaust.tres")

var cards_selected: int

func activate() -> void:
	# In case core was removed
	if coreui == null: return
	coreui.flash()
	
	Data.player_handler.draw_card()
	await Events.player_hand_drawn
	coreui.flash()
	Data.battle_ui.custom_pile_view.card_pile = CardPile.generate_from_ui(
		Data.battle_ui.hand.get_children())
	Data.battle_ui.custom_pile_view.show_current_view(
		"Select %s to give exhaust" % ("a card" if !coreui.slotted else "up to two cards"))
	
	await Data.get_tree().process_frame
	erase_then_select()
	
	Data.battle_ui.custom_pile_view.card_selected.connect(func(card:Card)->void:
		if !coreui.slotted: cards_selected = 1
		cards_selected += 1
		card.add_status(EXHAUST.duplicate())
		card.cardui.set_card(card)
		Data.battle_ui.custom_pile_view.card_pile.erase_card_with_id(card.unique_id)
		Data.battle_ui.custom_pile_view._update_view()
		if cards_selected > 1:
			Data.battle_ui.custom_pile_view._hide()
			return
		erase_then_select())


func erase_then_select() -> void:
	for cardmenu: CardMenuUI in Data.battle_ui.custom_pile_view.cards.get_children():
		if cardmenu.card.has_status("exhaust"):
			cardmenu.queue_free()
	Data.battle_ui.custom_pile_view.select_card(true)
