extends Card

var draw_amount := 2

# Using _init() is fine since Events is ready long before this is initialised
func _init() -> void:
	Events.update_card_stats.connect(func() -> void:
		if GameManager.true_draw_amount: tooltip_text = "Draw %s(%s)" % [draw_amount, draw_amount - 1]
		else: tooltip_text = "Draw %s" % draw_amount)


func apply_effects(_targets : Array[Node]) -> void:
	SFXPlayer.play(sound)
	Events.player_draw_cards.emit(draw_amount)
