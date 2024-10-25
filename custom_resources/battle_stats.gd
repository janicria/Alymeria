class_name BattleStats
extends Resource

@export_range(0,3) var battle_tier: int
@export_range(0,100) var weight: int
@export var pure: bool # Can't be infected
@export var enemies: PackedScene

var accumulated_weight := 0.0
var live_enemies: Array[Enemy]


func _init() -> void:
	Events.update_battle_stats.connect(update_battle)


func roll_gold_reward() -> int:
	var gold: int 
	match battle_tier: # Translation: (10 to 15) * ((biome + 1) / 2) with biome rounded up
		0: gold = randi_range(10, 15) * (ceili(Data.current_biome+2)/2) # Easy pool 
		1: gold = randi_range(10, 20) * (ceili(Data.current_biome+2)/2) # Regular pool
		2: gold = randi_range(15 ,25) * (ceili(Data.current_biome+2)/2) # Elite pool
		3: gold = randi_range(15, 25 * (Data.current_biome+2)) # Boss pool
	if Data.floor_is_infected: gold = ceili(gold*1.2)
	return gold


func turn_effects() -> void:
	pass


func update_battle() -> void:
	pass
