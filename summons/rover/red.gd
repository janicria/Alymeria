extends SummonAction


func setup() -> void:
	stats.summon.damaged.connect(
		func() -> void:
			play()
	)


func apply_effects(target: Node) -> void:
	stats.action_played(self)
	target.call("take_damage", get_modified_damage(3, target), false)
