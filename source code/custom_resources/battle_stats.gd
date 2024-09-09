class_name BattleStats
extends Resource

@export_range(0,4) var battle_tier: int
@export_range(0,100) var weight: int
@export var pure: bool # Can't be infected
@export var enemies: PackedScene

var accumulated_weight := 0.0


func roll_gold_reward() -> int:
	match battle_tier:
		0: 
			return (randi_range(10, 20)*(GameSave.current_biome+1)) /2
		1: #TODO: Check for infected enemy combats
			return (randi_range(5, 25)*(GameSave.current_biome+1)) /2
		2: # Elite
			return (randi_range(10, 30)*(GameSave.current_biome+1)) /2
		3: # Boss
			return randi_range(15, 25)*(GameSave.current_biome+1)
		4: # Snal
			return randi_range(15, 25)
	return INF #TODO: add error to logs then return (randi_range(5, 25)*(GameSave.current_biome+1)) /2
