extends ColorRect

const CORE_LABEL = preload("res://scences/views/treasure/core_label.tscn")

@onready var cores: HBoxContainer = %Cores


func add_cores(core_array: Array[Core]) -> void:
	for core in core_array:
		var core_label := CORE_LABEL.instantiate()
		cores.add_child(core_label)
		core_label.core_ui.core = core
		core_label.setup()


func _on_skip_button_pressed() -> void:
	queue_free()
