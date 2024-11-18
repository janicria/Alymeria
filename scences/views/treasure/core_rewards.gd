extends ColorRect

@onready var placeholder_label: Panel = %CoreA


func add_cores(core_array: Array[Core]) -> void:
	for core in core_array:
		var core_label := placeholder_label.duplicate()
		core_label.get_child(0).text = core.core_name
		core_label.get_child(1).core = core
		await get_tree().process_frame
		print(core_label.get_child(1).icon)
		core_label.get_child(1).icon.gui_input.connect(
			core_pressed.bind(core))
	placeholder_label.queue_free()


func core_pressed(event: InputEvent, core: Core) -> void:
	if event.is_action_pressed("right_mouse"):
		Data.core_handler.add_core(core)
		Data.removed_cores.erase(core)
		queue_free()


func _on_skip_button_pressed() -> void:
	queue_free()
