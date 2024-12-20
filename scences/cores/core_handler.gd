class_name CoreHandler extends VBoxContainer

signal core_activated(type: Core.Type)

const APPLY_INTERVAL := 0.5
#const HOW_SLOW_IS_GODOT := 20
const COREUI := preload("res://scences/cores/coreui.tscn")

@onready var slotted_cores: HBoxContainer = %SlottedCores
@onready var right_clickable_cores: GridContainer = %RightClickableCores
@onready var remaining_cores: GridContainer = %RemainingCores


func _ready() -> void:
	Data.core_handler = self


func activate_cores_of_type(type: Core.Type) -> void:
	if type == Core.Type.RIGHT_CLICK or type == Core.Type.EVENT:
		return
	
	var queue := get_all_coreuis().filter(
		func(coreui:CoreUI)->bool: 
			return coreui.core.type == type)
	
	if queue.is_empty():
	#	for i in HOW_SLOW_IS_GODOT: # Very slow it seems (0.3s)
		await get_tree().process_frame
		core_activated.emit(type)
		return
	
	var tween := create_tween()
	for coreui: CoreUI in queue: # Tweens > Timers
		tween.tween_callback(coreui.core.activate)
		tween.tween_callback(coreui.flash)
		tween.tween_interval(APPLY_INTERVAL)
	tween.finished.connect(func()->void:core_activated.emit(type))


func add_core(core: Core) -> void:
	var coreui := COREUI.instantiate()
	if slotted_cores.get_child_count() < 3:
		slotted_cores.add_child(coreui)
		coreui.slotted = true
	elif core.type == Core.Type.RIGHT_CLICK:
		right_clickable_cores.add_child(coreui)
	else: remaining_cores.add_child(coreui)
	coreui.core = core
	coreui.core.added()


func remove_core(core: Core) -> void:
	if get_core(core.core_name) == null: return
	for coreui: CoreUI in get_all_coreuis():
		if coreui.core == core:
			coreui.queue_free()


func get_core(core_name: String) -> Core:
	# Tree check is for cores queued for deletion
	for coreui: CoreUI in get_all_coreuis():
		if coreui.core.core_name == core_name && coreui.is_inside_tree():
			return coreui.core
	return null


func get_all_coreuis() -> Array:
	var coreuis: Array = slotted_cores.get_children()
	coreuis.append_array(right_clickable_cores.get_children())
	coreuis.append_array(remaining_cores.get_children())
	return coreuis


func _on_core_removed(coreui: CoreUI) -> void:
	coreui.core.removed()
