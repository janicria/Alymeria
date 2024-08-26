extends Card

@export var optional_sound : AudioStream

var draw_amount := 2

func _init() -> void:
	Events.update_card_stats.connect(
		func() -> void:
			if self.has_draw and GameSave.true_draw_amount:
				self.tooltip_text = str(draw_amount) + "(" + str(draw_amount - 1) + ")"
	)


func apply_effects(targets : Array[Node]) -> void:
	SFXPlayer.play(sound)
	Events.player_draw_cards.emit(draw_amount)
