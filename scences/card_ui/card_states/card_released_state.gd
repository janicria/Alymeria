extends CardState

var played : bool

func enter() -> void:
	played = false

	if !card_ui.targets.is_empty() and card_ui.has_targets():
		Events.tooltip_hide_requested.emit()
		if card_ui.add_back_to_hand():
			played = true
			card_ui. play()


func on_input(_event : InputEvent) -> void:
	if played:
		return
 
	transition_requested.emit(self, CardState.State.BASE)
