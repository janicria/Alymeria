class_name StatusUI
extends Control

@export var status: Status : set = set_status

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label


func set_status(value: Status) -> void:
	if !is_node_ready(): await ready
	
	status = value
	icon.texture = status.icon
	label.visible = status.stack_type != Status.StackType.NONE
	custom_minimum_size = icon.size
	
	if label.visible: custom_minimum_size = label.size + label.position
	
	if !status.status_changed.is_connected(status_changed):
		status.status_changed.connect(status_changed)
	
	status_changed()


func status_changed() -> void:
	if !status: return
	
	if status.duration <= 0 && status.stack_type == Status.StackType.DURATION:
		queue_free()
	
	# Allows negative stacks
	if status.stacks == 0 && status.stack_type == Status.StackType.INTENSITY:
		queue_free()
	
	if status.stack_type == Status.StackType.DURATION:
		label.text = str(status.duration)
	elif status.stack_type == Status.StackType.INTENSITY:
		label.text = str(status.stacks)
