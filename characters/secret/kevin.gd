extends Card


func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler) -> void:
	Data.battle.credits.begin()
