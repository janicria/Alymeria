class_name Cancel
extends Status


func initalise_target(_target: Node) -> void:
	Events.update_card_variant.emit("disabled", true, true)
	
	if !status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed)


func _on_status_changed() -> void:
	await Events.player_hand_drawn
	if duration <= 0: Events.update_card_variant.emit("disabled", false, true)
	else: Events.update_card_variant.emit("disabled", true, true)
