extends Card


func apply_effects(targets: Array[Node]) -> void:
	var barrier_effect := BarrierEffect.new()
	barrier_effect.amount = 4
	barrier_effect.sound = sound
	barrier_effect.execute(targets)
