extends CardState

var played : bool

func enter() -> void:
	played = false

	if !card_ui.targets.is_empty() && card_ui.targets:
		Events.hide_tooltip.emit()
		played = true
		card_ui.play()


func on_input(_event : InputEvent) -> void:
	if played:
		return
 
	transition_requested.emit(self, CardState.State.BASE)
