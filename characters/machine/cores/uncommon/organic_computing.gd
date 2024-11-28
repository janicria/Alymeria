extends Core


func activate() -> void:
	var summon := Summon.summon(Data.summons.pick_random())
	summon.stats = Data.summons.pick_random()
	if coreui.slotted:
		summon.stats.barrier += 14
		summon.stats.finisher.play()
