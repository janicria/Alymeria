extends Node

signal gold_changed

#Constant-related variables
const STARTING_GOLD := 50
const BASE_CARD_REWARDS := 4
const BASE_COMMON_WEIGHT := 85.0
const BASE_UNCOMMON_WEIGHT := 10.0
const BASE_RARE_WEIGHT := 5.0
enum Biome {FOREST, TOWN, CAVES, CITY, TRAIN, STORM, FINAL}

# Settings-related variables
var true_draw_amount := false
var true_deck_size := false
var card_pile_above_mana := true
var gameplay_tips := true

# Bestiary-related variables
var spider_bestiary_entry := false
var bat_bestiary_entry := false

# Misc-related variables
var gold := STARTING_GOLD : set = set_gold
var card_rewards := BASE_CARD_REWARDS
var common_weight := BASE_COMMON_WEIGHT
var uncommon_weight := BASE_UNCOMMON_WEIGHT
var rare_weight := BASE_RARE_WEIGHT
var character: CharacterStats
var current_biome := Biome.FOREST : set = set_current_biome

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
	"WEATHER": 1,
	"ENEMY_DAMAGE": 1,
	"ENEMY_HEALTH": 1,
	"INFECTION": 1,
	"ENEMY_MOVESET": 0,
	"ELITE_MOVESET": 0,
	"BOSS_MOVESET": 0,
	"WEATHER_MOVESET": 0,
	"UNCOMMON_CARD_RARITY": 0.0,
	"RARE_CARD_RARITY": 0.0
}

# Global variables
var card_pile_open := false : set = set_card_pile


func set_current_biome(value: Biome) -> void:
	current_biome = clampi(value, Biome.FOREST, (Biome.size()) -1)


# Prevents settings from opening the same frame a card pile closes
func set_card_pile(value: bool) -> void:
	await get_tree().process_frame
	card_pile_open = value


func reset_stats() -> void:
	gold = STARTING_GOLD
	reset_weights()


func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	
	# Logging
	print("Successful launch")
	var platform := "Unknown"
	if OS.has_feature("release"): platform = "Release ("
	else: platform = "Debug ("
	if OS.has_feature("linux"): platform += "Linux)"
	elif OS.has_feature("windows"): platform += "Windows)"
	else: platform += "Unknown)"; notify("Unable to detect OS", true)
	print("Version: %s %s" % [platform, ProjectSettings.get_setting("application/config/version")])


func notify(text: String, error := false) -> void:
	if error: printerr("[ERROR] " + text)
	else: printerr("[FAIL] " + text)
	OS.alert("Janicria did an oopsie and asks for you to send the file 'info.log' at the path '%s'. (Dw you can still play the game)" % ProjectSettings.globalize_path("user://logs/info.log"), "Oopsie daisy")


# TODO: lmao
func save_to_file() -> bool:
	var result: bool
	
	result = true
	if result: print("Game saved! - %s" % get_tree().get_frame())
	else: notify("Failed writing save file to path %s" % ProjectSettings.globalize_path("user://saves/save.exampleExtenstion"), true)
	
	return result


func set_gold(new_amount : int) -> void:
	gold = new_amount
	gold_changed.emit()


func reset_weights() -> void:
	common_weight = BASE_COMMON_WEIGHT
	uncommon_weight = BASE_UNCOMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT
