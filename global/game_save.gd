extends Node

signal gold_changed

#Constant-related variables
const STARTING_GOLD := 50
const BASE_CARD_REWARDS := 4
const BASE_COMMON_WEIGHT := 85.0
const BASE_UNCOMMON_WEIGHT := 10.0
const BASE_RARE_WEIGHT := 5.0  # Trust they have to be a floats
enum Biome {FOREST, TOWN, CAVES, CITY, TRAIN, STORM, FINAL}

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
var character: CharacterStats
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

# Console-related variables
var cheats := false
var dev := false


func _init() -> void:
	_log("Successful launch")
	if !OS.has_feature("release"): _log("Version: Debug " + ProjectSettings.get_setting("application/config/version"))
	elif OS.has_feature("linux"): _log("Version: Linux " + ProjectSettings.get_setting("application/config/version"))
	elif OS.has_feature("windows"): _log("Version: Windows " + ProjectSettings.get_setting("application/config/version"))


# 0= Regular/Error, 1= Failsafe 2= Editor
func _log(text: String, type := 0) -> void:
	if !OS.has_feature("release"):
		if type == 1: OS.alert(text, "Oopsie daisey")
		print(text)
	else: # TODO: Replace print statements with writing to a file
		print(text)
		match type:
			1: OS.alert("Janicria did an oopsie and asks for you to send the file 'info.log' at the path '[path]'. (Dw you can still play the game)", "Oopsie daisey")
			2: var test = RandomAttack.new(); test.explide()


func set_gold(new_amount : int) -> void:
	gold = new_amount
	gold_changed.emit()


func reset_weights() -> void:
	common_weight = BASE_COMMON_WEIGHT
	uncommon_weight = BASE_UNCOMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT
