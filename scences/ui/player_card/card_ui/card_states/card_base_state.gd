extends CardState

func enter() -> void:
	if !card_ui.is_node_ready(): 
		await card_ui.ready
	
	if card_ui.tween && card_ui.tween.is_running():
		card_ui.tween.kill()
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.DEFAULT_STYLEBOX)
	card_ui.reparent_requested.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO
	Events.hide_tooltip.emit()


func on_gui_input(event: InputEvent) -> void:
	if !card_ui.playable or card_ui.disabled: return
	
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)


func on_mouse_entered() -> void:
	if !card_ui.playable or card_ui.disabled: return
	card_ui.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)


func on_mouse_exited() -> void:
	if !card_ui.playable or card_ui.disabled: return
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.DEFAULT_STYLEBOX)
	Events.hide_tooltip.emit()
