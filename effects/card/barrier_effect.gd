class_name BarrierEffect extends Effect

var amount := 0


func execute(targets : Array[Node]) -> void:
	for target in targets:
		if target is Enemy or target is Player or target is Summon:
			target.stats.barrier += amount
			SFXPlayer.play(sound)
