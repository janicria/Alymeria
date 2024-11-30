extends SummonAction


func setup() -> void:
	if !stats.summon.damaged.is_connected(play):
		stats.summon.damaged.connect(play)


func apply_effects(target: Node) -> void:
	stats.action_played(self)
	target.call("take_damage", get_modified_damage(
		3, stats.summon.modifier_handler, target), false)
