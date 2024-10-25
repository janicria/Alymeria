class_name CoreHandler extends VBoxContainer

signal core_activated(type: Core.Type)

const APPLY_INTERVAL := 0.5 # Used for readability
const COREUI := preload("res://scences/cores/coreui.tscn")

@onready var slotted_cores: HBoxContainer = %SlottedCores
@onready var right_clickable_cores: GridContainer = %RightClickableCores
@onready var remaining_cores: GridContainer = %RemainingCores


func activate_cores_of_type(type: Core.Type) -> void:
	if type == Core.Type.RIGHT_CLICK or type == Core.Type.EVENT:
		return
	
	var queue := get_all_cores().filter(
		func(coreui:CoreUI)->bool: return coreui.core.type == type)
	if queue.is_empty():
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
	if get_all_cores().any(func(core_ui:CoreUI)->bool:
		return core.core_name == core_ui.core.core_name && core_ui.is_inside_tree()):
			return # Tree check above is for cores queued for deletion
	
	var coreui := COREUI.instantiate()
	if slotted_cores.get_child_count() < 3:
		slotted_cores.add_child(coreui)
		coreui.core.slotted = true
	elif core.type == Core.Type.RIGHT_CLICK:
		right_clickable_cores.add_child(coreui)
	else: remaining_cores.add_child(coreui)
	coreui.core = core


func get_all_cores(as_ui := true) -> Array:
	if as_ui:
		var coreuis: Array[Node] = slotted_cores.get_children()
		coreuis.append_array(right_clickable_cores.get_children())
		coreuis.append_array(remaining_cores.get_children())
		return coreuis
	var cores: Array[Core]
	for coreui in slotted_cores.get_children(): cores.append(coreui.core)
	for coreui in right_clickable_cores.get_children(): cores.append(coreui.core)
	for coreui in remaining_cores.get_children(): cores.append(coreui.core)
	return cores


func _on_core_removed(coreui: CoreUI) -> void:
	coreui.core.deactivate(coreui)
