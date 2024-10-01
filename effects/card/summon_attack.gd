class_name SummonAttack
extends Effect

var amount := 0


func execute(targets : Array[Node]) -> void:
	for target in targets:
		if !target:
			continue
		if target is Summon:
			Events.summon_do_attack.emit(target.stats.id, amount, false)
