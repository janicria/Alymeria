class_name Credits extends Control

@onready var camera_2d: Camera2D = %Camera2D


func _ready() -> void:
	set_process(false)


func begin() -> void: # *Ominous music plays*
	await get_tree().create_timer(3).timeout
	Data.console_banned = true
	Events.toggle_console_visible.emit()
	Data.map.get_parent().fix_node_positions = false
	Data.battle_ui.turn_counter.queue_free()
	set_process(true)


func finish() -> void:
	if !camera_2d.drag_horizontal_enabled: return
	camera_2d.drag_horizontal_enabled = false
	await get_tree().create_timer(2).timeout
	OS.alert("Bye")
	get_tree().quit()


func _process(_delta: float) -> void:
	camera_2d.position.y += 0.4
	if camera_2d.position.y > camera_2d.limit_bottom:
		finish()
