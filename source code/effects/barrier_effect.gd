class_name BarrierEffect
extends Effect

var amount := 0


func execute(targets : Array[Node]) -> void:
	for target in targets:
		if !target:
			continue
		if target is Enemy or target is Player:
			target.stats.barrier += amount
			SFXPlayer.play(sound)
