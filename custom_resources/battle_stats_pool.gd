class_name BattleStatsPool extends Resource

@export var pool: Array[BattleStats]

var total_weights_by_tier := [0.0, 0.0, 0.0, 0.0]


func _get_all_battles_from_tier(tier: int) -> Array[BattleStats]:
	if pool.filter(func(battle: BattleStats) -> bool: return battle.battle_tier == tier).is_empty():
		# TODO: Restock pool here
		pass
	
	return pool.filter(func(battle: BattleStats) -> bool:
		return battle.battle_tier == tier)


func setup() -> void:
	for i in total_weights_by_tier.size():
		_setup_weights_for_tier(i)


func _setup_weights_for_tier(tier: int) -> void:
	var battles := _get_all_battles_from_tier(tier)
	total_weights_by_tier[tier] = 0.0
	
	for battle: BattleStats in battles:
		total_weights_by_tier[tier] += battle.weight
		battle.accumulated_weight = total_weights_by_tier[tier]


func get_random_battle_from_tier(tier: int) -> BattleStats:
	var roll := randf_range(0.0, total_weights_by_tier[tier])
	var battles := _get_all_battles_from_tier(tier)
	
	for battle: BattleStats in battles:
		if battle.accumulated_weight >= roll:
			return battle
	
	# Remember to update battle_stats_pool export var in MapGenerator with new battles
	return null
