class_name SummonHandler extends Node2D

signal actions_finished


func _ready() -> void:
	Data.summon_handler = self


func start_turn() -> void:
	await get_tree().process_frame # Needed for signal timings
	for summon: Summon in get_children():
		# Loop somehow gets ran even if get_children is empty
		if !get_child_count(): break
		summon.stats.base_action.play()
		await summon.stats.base_action.finished
	actions_finished.emit()


func start_of_turn_barrier_and_statuses() -> void:
	for summon: Summon in get_children():
		summon.do_turn()


func end_turn() -> void:
	for summon: Summon in get_children():
		summon.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)
