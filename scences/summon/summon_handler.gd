class_name SummonHandler extends Node2D

signal actions_finished


func start_turn() -> void:
	for summon: Summon in get_children():
		#summon.stats.base_action.play()
		#await summon.stats.base_action.finished
		await get_tree().process_frame
	actions_finished.emit()
