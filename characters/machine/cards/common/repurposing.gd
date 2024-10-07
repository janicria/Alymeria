extends Card

var base_amount := 2

# Using _init() is fine since Events is ready long before this is initialised
func _init() -> void:
	Events.update_card_stats.connect(func() -> void:
		if GameManager.true_draw_amount: tooltip_text = "Draw %s(%s)\nUncache 1" % [base_amount, base_amount - 1]
		else: tooltip_text = "Draw %s\nUncache 1" % base_amount)


func apply_effects(_otargets: Array[Node], _modifiers: ModifierHandler) -> void:
	SFXPlayer.play(sound)
	Events.player_draw_cards.emit(base_amount)
