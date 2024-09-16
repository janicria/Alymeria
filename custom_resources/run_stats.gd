class_name RunStats
extends Resource

signal gold_changed

const STARTING_GOLD := 50
const BASE_CARD_REWARDS := 4
const BASE_COMMON_WEIGHT := 85
const BASE_UNCOMMON_WEIGHT := 10
const BASE_RARE_WEIGHT := 5.0  # Trust me this has to be a float

@export var gold := STARTING_GOLD : set = set_gold
@export var card_rewards := BASE_CARD_REWARDS
@export_range(0, 100) var common_weight := BASE_COMMON_WEIGHT
@export_range(0, 100) var uncommon_weight := BASE_UNCOMMON_WEIGHT
@export_range(0, 100) var rare_weight := BASE_RARE_WEIGHT


func set_gold(new_amount : int) -> void:
	gold = new_amount
	gold_changed.emit()


func reset_weights() -> void:
	common_weight = BASE_COMMON_WEIGHT
	uncommon_weight = BASE_UNCOMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT
