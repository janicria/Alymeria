class_name SummonHandler extends Node2D


func _ready() -> void:
	Data.summon_handler = self


func start_of_turn_barrier_and_statuses() -> void:
	for summon: Summon in get_children():
		summon.do_turn()


func end_turn() -> void:
	for summon: Summon in get_children():
		summon.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)
