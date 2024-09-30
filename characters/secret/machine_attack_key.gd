extends Card


func apply_effects(targets : Array[Node]) -> void:
	for Object in targets:
		if !Object is Summon:
			targets.erase(Object)
	if targets:
		var summon_attack := SummonAttack.new()
		summon_attack.amount = 1
		SFXPlayer.play(sound)
		summon_attack.execute(targets)
