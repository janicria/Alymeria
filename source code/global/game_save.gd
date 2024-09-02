extends Node

signal gold_changed

#Constant-related variables
const STARTING_GOLD := 50
const BASE_CARD_REWARDS := 4
const BASE_COMMON_WEIGHT := 85
const BASE_UNCOMMON_WEIGHT := 10
const BASE_RARE_WEIGHT := 5.0  # Trust me this has to be a float

# Settings-related variables
var true_draw_amount := false
var true_deck_size := false
var card_pile_above_mana := false
var gameplay_tips := false

# Bestiary-related variables
var spider_bestiary_entry := false
var bat_bestiary_entry := false

# Gameplay-related variables
var character: CharacterStats
enum Biome {FOREST, TOWN, CAVES, CITY, TRAIN, STORM, FINAL}
var current_biome := Biome.FOREST
var biome_floors = {
	Biome.FOREST: 12,
	Biome.TOWN: 16,
	Biome.CAVES: 8,
	Biome.CITY: 16,
	Biome.TRAIN: 8,
	Biome.STORM: 8,
	Biome.FINAL: INF,
}
var gold := STARTING_GOLD : set = set_gold
var card_rewards := BASE_CARD_REWARDS
@export_range(0, 100) var common_weight := BASE_COMMON_WEIGHT
@export_range(0, 100) var uncommon_weight := BASE_UNCOMMON_WEIGHT
@export_range(0, 100) var rare_weight := BASE_RARE_WEIGHT

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
