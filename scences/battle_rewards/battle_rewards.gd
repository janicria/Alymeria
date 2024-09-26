class_name BattleReward
extends Control

const CARD_REWARDS := preload("res://scences/ui/card_rewards.tscn")
const REWARD_BUTTON := preload("res://scences/ui/reward_button.tscn")
const GOLD_ICON := preload("res://assets/ui/gold.png")
const GOLD_TEXT := "%s gold"
const CARD_ICON := preload("res://assets/ui/rarity.png")
const CARD_TEXT := "Add a New Card"
const REGULAR_POTION_ICON := preload("res://assets/art/objects/tile_0114.png")
#const POTION_TEXT := ""

@export var character_stats: CharacterStats

@onready var rewards: VBoxContainer = %Rewards

var card_reward_total_weight := 0.0
var card_rarity_weights := {
	Card.Rarity.RARE: 0.0,
	Card.Rarity.UNCOMMON: 0.0,
	Card.Rarity.COMMON: 0.0
}


func _ready() -> void:
	character_stats = GameManager.character
	
	for node: Node in rewards.get_children():
		node.queue_free()


func add_card_reward() -> void:
	var card_reward := REWARD_BUTTON.instantiate() as RewardButton
	card_reward.reward_icon = CARD_ICON
	card_reward.reward_text = CARD_TEXT
	card_reward.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(card_reward)


func add_gold_reward(amount: int) -> void:
	var gold_reward := REWARD_BUTTON.instantiate() as RewardButton
	gold_reward.reward_icon = GOLD_ICON
	gold_reward.reward_text = GOLD_TEXT % amount
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(amount))
	rewards.add_child.call_deferred(gold_reward)


func _show_card_rewards() -> void:
	var card_rewards := CARD_REWARDS.instantiate() as CardRewards
	add_child(card_rewards)
	card_rewards.card_reward_selected.connect(_on_card_reward_taken)
	
	var card_reward_array: Array[Card] = []
	var available_cards: Array[Card] = character_stats.card_pool.duplicate_cards()
	
	# RNG for selecting each card (dark magic)
	for i in GameManager.card_rewards:
		setup_card_rarity_chances()
		var roll := randf_range(0.0, card_reward_total_weight)
		
		for rarity: Card.Rarity in card_rarity_weights:
			if rarity == Card.Rarity.COMMON:
				_modify_weights(rarity)
				var picked_card := _get_random_available_card(available_cards, rarity)
				card_reward_array.append(picked_card)
				available_cards.erase(picked_card)
				break
			elif card_rarity_weights[rarity] > roll:
				_modify_weights(rarity)
				var picked_card := _get_random_available_card(available_cards, rarity)
				card_reward_array.append(picked_card)
				available_cards.erase(picked_card)
				break
	
	card_rewards.rewards = card_reward_array
	card_rewards.show()


func setup_card_rarity_chances() -> void:
	card_reward_total_weight = GameManager.common_weight + GameManager.uncommon_weight + GameManager.rare_weight
	card_rarity_weights[Card.Rarity.COMMON] = GameManager.common_weight
	card_rarity_weights[Card.Rarity.UNCOMMON] = GameManager.uncommon_weight + GameManager.multipliers.get("UNCOMMON_CARD_RARITY")
	card_rarity_weights[Card.Rarity.RARE] = GameManager.rare_weight + GameManager.multipliers.get("RARE_CARD_RARITY")
	var biome := GameManager.current_biome
	if biome:
		card_rarity_weights[Card.Rarity.UNCOMMON] *= (biome * 2)
		card_rarity_weights[Card.Rarity.RARE] += biome


# Increments rare weights over time (reuse for pot chances)
func _modify_weights(rarity_rolled: Card.Rarity) -> void:
	if rarity_rolled == Card.Rarity.UNCOMMON:
		GameManager.common_weight = RunStats.BASE_COMMON_WEIGHT - GameManager.rare_weight
		GameManager.uncommon_weight = GameManager.BASE_UNCOMMON_WEIGHT
	else: # Increases uncommon chances
		GameManager.uncommon_weight = clampf(GameManager.uncommon_weight + 8.0, GameManager.BASE_UNCOMMON_WEIGHT, 80.0)
		GameManager.common_weight = GameManager.BASE_COMMON_WEIGHT - GameManager.uncommon_weight
	
	if rarity_rolled == Card.Rarity.RARE:
		GameManager.rare_weight = RunStats.BASE_RARE_WEIGHT
		GameManager.common_weight = RunStats.BASE_COMMON_WEIGHT
		GameManager.uncommon_weight = RunStats.BASE_UNCOMMON_WEIGHT
	else: # Increases rare chances
		GameManager.rare_weight = clampf(GameManager.rare_weight + 4.0, GameManager.BASE_RARE_WEIGHT, 50.0)
		GameManager.common_weight = GameManager.BASE_COMMON_WEIGHT - GameManager.rare_weight
	
	while card_reward_total_weight > 100:
		GameManager.common_weight -= 1
		setup_card_rarity_chances()
	while card_reward_total_weight < 100:
		GameManager.common_weight += 1
		setup_card_rarity_chances()


# Ensures that you get a card that has the rarity which was rolled by _show_card_rewards()
func _get_random_available_card(available_cards: Array[Card], with_rarity: Card.Rarity) -> Card:
	var all_possible_cards := available_cards.filter(
		func(card: Card)-> int:
			return card.rarity == with_rarity
	)
	return all_possible_cards.pick_random()


func _on_card_reward_taken(card: Card) -> void:
	if !character_stats or !card:
		return
	
	print("Drafted %s" % card.id)
	GameManager.character.deck.add_card(card)


func _on_gold_reward_taken(amount: int) -> void:
	if ! GameManager:
		return
	
	GameManager.gold += amount


func _on_back_button_pressed() -> void:
	Events.battle_reward_exited.emit()
