extends CardState

func enter() -> void:
	if !card_ui.is_node_ready():
		await card_ui.ready

	if card_ui.tween && card_ui.tween.is_running():
		card_ui.tween.kill()

	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	card_ui.reparent_requested.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO
	Events.tooltip_hide_requested.emit()

func on_gui_input(event: InputEvent) -> void:
	if !card_ui.playable or card_ui.disabled:
		return
	
	if event.is_action_pressed("left_mouse_pressed"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)


func on_mouse_entered() -> void:
	if !card_ui.playable or card_ui.disabled:
		return
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)
	Events.card_tooltip_requested.emit(card_ui.card.effect_description)


func on_mouse_exited() -> void:
	if !card_ui.playable or card_ui.disabled: return
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()
