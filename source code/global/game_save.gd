extends Node

signal gold_changed

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
var gold := 0

# Console-related variables
var cheats := false
var dev_mode := false

func set_gold(new_amount : int) -> void:
	gold = new_amount
	gold_changed.emit()
