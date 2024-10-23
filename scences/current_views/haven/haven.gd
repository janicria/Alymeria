extends Control


func _on_button_pressed() -> void:
	Events.haven_exited.emit()
