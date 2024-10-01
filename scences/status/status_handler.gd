class_name StatusHandler
extends GridContainer

signal statuses_applied(type: Status.Type)

const STATUS_INTERVAL_SECONDS := 0.25
const STATUS_UI := preload("res://scences/status/status_ui.tscn")

@export var status_owner: Node2D


func apply_statuses_by_type(type: Status.Type) -> void:
	if type == Status.Type.EVENT: 
		return
	
	var status_queue: Array[Status] = _get_all_statuses().filter(
		func(status: Status) -> bool: 
			return status.type == type)
	
	if status_queue.is_empty():
		statuses_applied.emit(type)
		return
	
	var tween := create_tween()
	for status: Status in status_queue:
		tween.tween_callback(status.apply_status.bind(status_owner))
		tween.tween_interval(STATUS_INTERVAL_SECONDS)
	
	tween.finished.connect(func()->void: statuses_applied.emit(type))


func add_status(status: Status) -> void:
	# Adds a new status if owner doesn't already have it
	if !_has_status(status.id):
		var new_status_ui := STATUS_UI.instantiate() as StatusUI
		add_child(new_status_ui)
		new_status_ui.status = status
		new_status_ui.status.status_applied.connect(_on_status_applied)
		new_status_ui.status.initalise_target(status_owner)
		return
	
	# No need to do anything to the status if it can't stack
	if status.stack_type == Status.StackType.NONE:
		return
	
	# Increases status duration
	if status.stack_type == Status.StackType.DURATION or status.stack_type == Status.StackType.INTENSE_DURATION:
		_get_status(status.id).duration += status.duration
		return
	
	# Increases status stacks
	if status.stack_type == Status.StackType.INTENSITY:
		_get_status(status.id).stacks += status.stacks


func _has_status(id: String) -> bool:
	for status_ui: StatusUI in get_children():
		if status_ui.status.id == id:
			return true
	
	return false


func _get_status(id: String) -> Status:
	for status_ui: StatusUI in get_children():
		if status_ui.status.id == id:
			return status_ui.status
	
	GameManager.notify("Unable to return status using id", true)
	return null


func _get_all_statuses() -> Array[Status]:
	var statuses: Array[Status] = []
	for status_ui: StatusUI in get_children():
		statuses.append(status_ui.status)
	return statuses


func _on_status_applied(status: Status) -> void:
	if status.stack_type == Status.StackType.DURATION or status.stack_type == Status.StackType.INTENSE_DURATION:
		status.duration -= 1
