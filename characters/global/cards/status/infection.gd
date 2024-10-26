extends Card


func drawn() -> void:
	Data.get_tree().get_first_node_in_group("player").handler.add_card(self, "discard")
