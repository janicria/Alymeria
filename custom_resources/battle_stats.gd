class_name BattleStats
extends Resource

@export_range(0,4) var battle_tier: int
@export_range(0,100) var weight: int
@export var pure: bool # Can't be infected
@export var enemies: PackedScene

var accumulated_weight := 0.0


func roll_gold_reward() -> int:
	match battle_tier: # Translation: 10 to (15 * (biome / 2)) with (biome / 2) being rounded up
		0: # Easy pool 
			return randi_range(10, 15 * ceili(((GameManager.current_biome+1)/2)))
		1: #TODO: Check for infected enemy combats
			return randi_range(10, 30 * ceili(((GameManager.current_biome+1)/2)))
		2: # Elite
			return randi_range(15, 35 * ceili(((GameManager.current_biome+1)/2)))
		3: # Boss
			return randi_range(15, 25 * (GameManager.current_biome+1))
		4: # Snal
			return randi_range(15, 25)
	GameManager.notify("Unable to return gold reward")
	return (randi_range(5, 25)*(GameManager.current_biome+1)) /2
