class_name Cancel extends Status


func initalise_target(_target: Node) -> void:
	Events.update_hand_state.emit()
