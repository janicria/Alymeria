extends Card

var base_amount := 2


func drawn() -> void:
	if tooltip_text == "Set in script": update_tooltip_text()
	Events.update_draw_card_ui.connect(update_tooltip_text)


func update_tooltip_text() -> void: # I ain't doing a trenary that long
	if Data.true_draw_amount: tooltip_text = "Draw %s(%s)\nUncache 1" % [base_amount, base_amount - 1]
	else: tooltip_text = "Draw %s\nUncache 1" % base_amount
	cardui.set_card(self)


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	SFXPlayer.play(sound)
	Events.player_draw_cards.emit(base_amount)
	var battle_ui: BattleUI = targets[0].get_parent().battle_ui
	battle_ui.cache_pile_view.show_current_view("Select a card to uncache")
	await targets[0].get_tree().process_frame
	battle_ui.cache_pile_view.select_card()
	battle_ui.cache_pile_view.card_selected.connect(func(card:Card)->void:
		if Data.character.cache_tokens >= card.cache_cost:
			card.cached()
			Data.character.cache_tokens -= card.cache_cost
			battle_ui.hand.add_card(card)
			battle_ui.cache_pile_view.card_pile.remove_card(card)
			battle_ui.cache_pile_view._hide())
