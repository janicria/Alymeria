class_name SummonHandler extends Node2D

signal actions_finished


func start_turn() -> void:
	await get_tree().process_frame # Needed for signal timings
	for summon: Summon in get_children():
		# Loop somehow gets ran even if get_children is empty
		if !get_child_count(): break
		summon.stats.base_action.play()
		await summon.stats.base_action.finished
	actions_finished.emit()
