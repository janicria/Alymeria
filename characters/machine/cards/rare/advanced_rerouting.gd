extends Card


func apply_effects(_targets: Array[Node]) -> void:
	Events.update_card_variant.emit("cost", -1, "hand")