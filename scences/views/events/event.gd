extends Control


func _on_button_pressed() -> void:
	Events.events_extied.emit()
