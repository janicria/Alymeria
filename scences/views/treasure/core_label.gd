class_name CoreLabel extends Panel

@onready var label: Label = %Label
@onready var core_ui: CoreUI = %CoreUI


func setup() -> void:
	label.text = core_ui.core.core_name
	core_ui.icon.gui_input.connect(core_pressed)


func core_pressed(event: InputEvent) -> void:
	if event.is_action_pressed("right_mouse"):
		Data.core_handler.add_core(core_ui.core)
		Data.removed_cores.erase(core_ui.core)
		get_parent().queue_free()
