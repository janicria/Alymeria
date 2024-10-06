extends Card


func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler) -> void:
	Events.update_card_variant.emit("cost", -1)
