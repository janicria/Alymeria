extends CardState

const DRAG_MINIMUM_THERESHOLD := 0.05

var mininium_drag_time_elapsed := false


func enter() -> void:
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	# Allows the card ui leave the hand
	card_ui.reparent(ui_layer)
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.DRAG_STYLEBOX)
	Events.card_drag_started.emit(card_ui)
	
	mininium_drag_time_elapsed = false
	var thereshold_timer := get_tree().create_timer(DRAG_MINIMUM_THERESHOLD, false)
	thereshold_timer.timeout.connect(func()->void: mininium_drag_time_elapsed = true)


func exit() -> void:
	Events.card_drag_ended.emit(card_ui)


func on_input(event: InputEvent) -> void:
	var single_targeted := card_ui.card.is_single_targeted()
	var mouse_motion := event is InputEventMouseMotion
	var cancel := event.is_action_pressed("right_mouse")
	var confirm := event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")

	if single_targeted && mouse_motion && card_ui.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return

	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset

	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif mininium_drag_time_elapsed && confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
