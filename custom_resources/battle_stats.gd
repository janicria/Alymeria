class_name BattleStats
extends Resource

@export_range(0,4) var battle_tier: int
@export_range(0,100) var weight: int
@export var pure: bool # Can't be infected
@export var enemies: PackedScene

var accumulated_weight := 0.0

#TODO: Check for infected enemy combats
func roll_gold_reward() -> int:
	match battle_tier: # Translation: (10 to 15) * ((biome + 1) / 2) with biome rounded up
		0: return randi_range(10, 15) * (ceili(GameManager.current_biome+2)/2) # Easy pool 
		1: return randi_range(10, 20) * (ceili(GameManager.current_biome+2)/2) # Regular pool
		2: return randi_range(15 ,25) * (ceili(GameManager.current_biome+2)/2) # Elite pool
		3: return randi_range(15, 25 * (GameManager.current_biome+2)) # Boss pool
	GameManager.notify("Unable to return gold reward")
	return (randi_range(5, 25)*(GameManager.current_biome+1)) /2
