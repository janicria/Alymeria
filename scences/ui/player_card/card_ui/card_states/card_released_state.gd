extends CardState

var played : bool


func enter() -> void:
	played = false
	
	if !card_ui.targets.is_empty():
		if card_ui.card.target == Card.Target.SINGLE_ENEMY:
			if !card_ui.targets[0] is Enemy: return
		if card_ui.card.target == Card.Target.SUMMON:
			if !card_ui.targets[0] is Summon: return
		
		Events.hide_tooltip.emit()
		played = true
		card_ui.play()


func on_input(_event: InputEvent) -> void:
	if played: 
		return
	
	transition_requested.emit(self, CardState.State.BASE)
