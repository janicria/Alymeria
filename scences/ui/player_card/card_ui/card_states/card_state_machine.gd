class_name CardSateMachine extends Node

@export var inital_state: CardState

var current_state: CardState
var states := {}


func init(card: CardUI) -> void:
	for child in get_children():
		if child is CardState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.card_ui = card

	if inital_state:
		inital_state.enter()
		current_state = inital_state


func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)


func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)


func on_mouse_entered() -> void:
	if current_state: current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state: current_state.on_mouse_exited()


func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	if from != current_state:
		return

	var new_state: CardState = states[to]
	if !new_state:
		return

	if current_state:
		current_state.exit()

	new_state.enter()
	current_state = new_state
