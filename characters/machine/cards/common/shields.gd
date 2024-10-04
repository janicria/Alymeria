extends Card

var base_amount := 4


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var barrier_effect := BarrierEffect.new()
	barrier_effect.amount = base_amount
	barrier_effect.sound = sound
	barrier_effect.execute(targets)
