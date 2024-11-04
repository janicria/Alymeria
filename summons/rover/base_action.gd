extends SummonAction


func apply_effects(_target: Node) -> void:
	Data.player_handler.draw_card()
