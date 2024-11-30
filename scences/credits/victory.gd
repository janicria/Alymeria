class_name Credits extends Control

@onready var camera_2d: Camera2D = %Camera2D


func _ready() -> void:
	set_process(false)


func begin() -> void: # *Ominous music plays*
	await get_tree().create_timer(3).timeout
	Data.map.get_parent().fix_node_positions = false
	set_process(true)


func _process(_delta: float) -> void:
	Data.map.get_parent().fix_node_positions = false
	camera_2d.position.y += 0.4
	#if camera_2d.position.y = X / is stopped: do something cool
