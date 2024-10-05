extends Card


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	targets.filter(func(target: Node)->bool: return target is Summon)
	if targets:
		var summon_attack := SummonAttack.new()
		summon_attack.amount = 1
		SFXPlayer.play(sound)
		summon_attack.execute(targets)
