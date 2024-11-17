extends ColorRect

@onready var label_a: Label = %LabelA
@onready var core_ui_a: CoreUI = %CoreUIA
@onready var label_b: Label = %LabelB
@onready var core_ui_b: CoreUI = %CoreUIB


func add_cores(core_a: Core, core_b: Core) -> void:
	core_ui_a.core = core_a
	core_ui_b.core =core_b
	core_ui_a.icon.gui_input.connect(core_pressed.bind(core_a))
	core_ui_b.icon.gui_input.connect(core_pressed.bind(core_b))


func core_pressed(event: InputEvent, core: Core) -> void:
	if event.is_action_pressed("right_mouse"):
		Data.core_handler.add_core(core)
		Data.removed_cores.erase(core)
		queue_free()


func _on_skip_button_pressed() -> void:
	queue_free()
