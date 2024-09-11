extends Node

signal gold_changed

#Constant-related variables
const STARTING_GOLD := 50
const BASE_CARD_REWARDS := 4
const BASE_COMMON_WEIGHT := 85.0
const BASE_UNCOMMON_WEIGHT := 10.0
const BASE_RARE_WEIGHT := 5.0  # Trust they have to be a floats
enum Biome {FOREST, TOWN, CAVES, CITY, TRAIN, STORM, FINAL}
enum Multipliers {WEATHER, ENEMY_DAMAGE, ENEMY_HEALTH, INFECTION, ENEMY_MOVESET, ELITE_MOVESET, BOSS_MOVESET, WEATHER_MOVESET}

# Settings-related variables
var true_draw_amount := false
var true_deck_size := false
var card_pile_above_mana := false
var gameplay_tips := false

# Bestiary-related variables
var spider_bestiary_entry := false
var bat_bestiary_entry := false

# Misc-related variables
var gold := STARTING_GOLD : set = set_gold
var card_rewards := BASE_CARD_REWARDS
var common_weight := BASE_COMMON_WEIGHT
var uncommon_weight := BASE_UNCOMMON_WEIGHT
var rare_weight := BASE_RARE_WEIGHT
var character: CharacterStats : set = update_stats
var current_biome := Biome.FOREST

# Dictionary-related variables
var biome_floors := {
	Biome.FOREST: 12,
	Biome.TOWN: 16,
	Biome.CAVES: 8,
	Biome.CITY: 16,
	Biome.TRAIN: 8,
	Biome.STORM: 8,
	Biome.FINAL: INF
}
var multipliers := {
	Multipliers.WEATHER: 1,
	Multipliers.ENEMY_DAMAGE: 1,
	Multipliers.ENEMY_HEALTH: 1,
	Multipliers.INFECTION: 1,
	Multipliers.ENEMY_MOVESET: 0,
	Multipliers.ELITE_MOVESET: 0,
	Multipliers.BOSS_MOVESET: 0,
	Multipliers.WEATHER_MOVESET: 0
}

# Console-related variables
var cheats := false
var dev_mode := false


func set_gold(new_amount : int) -> void:
	gold = new_amount
	gold_changed.emit()


func reset_weights() -> void:
	common_weight = BASE_COMMON_WEIGHT
	uncommon_weight = BASE_UNCOMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT


func update_stats(new_stats: CharacterStats) -> void:
	character = new_stats
