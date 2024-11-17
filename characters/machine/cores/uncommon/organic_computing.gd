extends Core


# TODO: Add options for other summons
func activate() -> void:
	var summon := Summon.summon(Data.summons.pick_random())
	#summon.stats = Data.summons.pick_random()
	if coreui.slotted:
		summon.stats.barrier += 18
		summon.stats.special_action.play()
