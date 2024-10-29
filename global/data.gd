extends Node

signal gold_changed

var player_handler: PlayerHandeler
var main: Main
var battle_ui: BattleUI

# Constants 
const STARTING_GOLD := 50
const BASE_CARD_REWARDS := 4
const BASE_COMMON_WEIGHT := 85.0
const BASE_UNCOMMON_WEIGHT := 10.0
const BASE_RARE_WEIGHT := 5.0
enum Biome {FOREST, TOWN, CAVES, CITY, TRAIN, STORM, FINAL}

# Settings variables
var true_draw_amount := false
var true_deck_size := false
var card_pile_above_mana := true
var gameplay_tips := true
var speedy_cards := false

# Stats variables
var damage_taken := 0
var blocked_damage := 0
var damage_dealt := 0
var health_healed := 0
var cheats := false

# Bestiary variables
var spider_bestiary_entry := false
var bat_bestiary_entry := false

# Misc variables
var gold := STARTING_GOLD : set = set_gold
var card_rewards := BASE_CARD_REWARDS
var common_weight := BASE_COMMON_WEIGHT
var uncommon_weight := BASE_UNCOMMON_WEIGHT
var rare_weight := BASE_RARE_WEIGHT
var character: CharacterStats
var current_biome := Biome.FOREST : set = set_current_biome
var floor_is_infected := false
var card_pile_open := false : set = set_card_pile
var console_banned := false
var console_open := false
var bestiary_open := false
var turn_number := 0
var biome_floors := {
	Biome.FOREST: 12,
	Biome.TOWN: 16,
	Biome.CAVES: 8,
	Biome.CITY: 16,
	Biome.TRAIN: 8,
	Biome.STORM: 8,
	Biome.FINAL: -1}
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
	"RARE_CARD_RARITY": 0.0}


func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Events.update_turn_number.connect(func(number:int)->void:turn_number = number)
	
	print("Successful launch")
	print("Version: %s (%s)" % [ProjectSettings.get_setting("application/config/version"), "Linux" if OS.has_feature("linux") else "Windows"])


func set_current_biome(value: Biome) -> void:
	current_biome = clampi(value, Biome.FOREST, (Biome.size()) -1)


# Prevents settings from opening the same frame a card pile closes
func set_card_pile(value: bool) -> void:
	await get_tree().process_frame
	card_pile_open = value


func set_gold(new_amount : int) -> void:
	gold = new_amount
	gold_changed.emit()


func reset_stats() -> void:
	gold = STARTING_GOLD
	damage_dealt = 0
	damage_taken = 0
	blocked_damage = 0
	health_healed = 0
	cheats = false
	common_weight = BASE_COMMON_WEIGHT
	uncommon_weight = BASE_UNCOMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT


# TODO: lmao
func save_to_file() -> bool:
	var result: bool
	result = true
	if result: print("Game saved! - %d" % (get_tree().get_frame()/60))
	else: OS.alert("Failed writing save file to path %s" % ProjectSettings.globalize_path("user://saves/save.exampleExtenstion"))
	
	return result
