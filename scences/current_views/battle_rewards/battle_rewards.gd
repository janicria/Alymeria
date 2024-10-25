class_name BattleReward
extends Control

const CARD_REWARDS := preload("res://scences/ui/battle/card_rewards.tscn")
const REWARD_BUTTON := preload("res://scences/ui/battle/reward_button.tscn")
const GOLD_ICON := preload("res://assets/ui/universal/gold.png")
const GOLD_TEXT := "%s gold"
const CARD_ICON := preload("res://assets/ui/cards/orb.png")
const CARD_TEXT := "Add a New Card"
const REGULAR_POTION_ICON := preload("res://assets/objects/tile_0114.png")
#const POTION_TEXT := ""

@onready var rewards: VBoxContainer = %Rewards
@onready var title: Label = %Title

var card_reward_total_weight := 0.0
var card_rarity_weights := {
	Card.Rarity.RARE: 0.0,
	Card.Rarity.UNCOMMON: 0.0,
	Card.Rarity.COMMON: 0.0
}


func _ready() -> void:
	# Removes placeholder rewards
	for node: Node in rewards.get_children(): 
		node.queue_free()
	
	match randi_range(0, 6):
		0: title.text = "Victory"
		1: title.text = "Not even a stratch"
		2: title.text = "Rewards!"
		3: title.text = "Reward text"
		4: title.text = "Cool cards here"
		5: title.text = "Better skip these"


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
	var available_cards: Array[Card] = Data.character.card_pool.duplicate_cards()
	
	# RNG for selecting each card (dark magic)
	for i in Data.card_rewards:
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
	card_reward_total_weight = Data.common_weight + Data.uncommon_weight + Data.rare_weight
	card_rarity_weights[Card.Rarity.COMMON] = Data.common_weight
	card_rarity_weights[Card.Rarity.UNCOMMON] = Data.uncommon_weight + Data.multipliers.get("UNCOMMON_CARD_RARITY")
	card_rarity_weights[Card.Rarity.RARE] = Data.rare_weight + Data.multipliers.get("RARE_CARD_RARITY")
	if  Data.current_biome:
		card_rarity_weights[Card.Rarity.UNCOMMON] *= 1+(Data.current_biome / 2)
		card_rarity_weights[Card.Rarity.RARE] +=  1+(Data.current_biome / 5)


# Increments rare weights over time (reuse for pot chances)
func _modify_weights(rarity_rolled: Card.Rarity) -> void:
	if rarity_rolled == Card.Rarity.UNCOMMON:
		Data.common_weight = Data.BASE_COMMON_WEIGHT - Data.rare_weight
		Data.uncommon_weight = Data.BASE_UNCOMMON_WEIGHT
	else: # Increases uncommon chances
		Data.uncommon_weight = clampf(Data.uncommon_weight + 8.0, Data.BASE_UNCOMMON_WEIGHT, 80.0)
		Data.common_weight = Data.BASE_COMMON_WEIGHT - Data.uncommon_weight
	
	if rarity_rolled == Card.Rarity.RARE:
		Data.rare_weight = Data.BASE_RARE_WEIGHT
		Data.common_weight = Data.BASE_COMMON_WEIGHT
		Data.uncommon_weight = Data.BASE_UNCOMMON_WEIGHT
	else: # Increases rare chances
		Data.rare_weight = clampf(Data.rare_weight + 2.0, Data.BASE_RARE_WEIGHT, 50.0)
		Data.common_weight = Data.BASE_COMMON_WEIGHT - Data.rare_weight
	
	while card_reward_total_weight > 100:
		Data.common_weight -= 1
		setup_card_rarity_chances()
	while card_reward_total_weight < 100:
		Data.common_weight += 1
		setup_card_rarity_chances()


# Ensures that you get a card with the rarity rolled by _show_card_rewards()
func _get_random_available_card(available_cards: Array[Card], with_rarity: Card.Rarity) -> Card:
	var all_possible_cards := available_cards.filter(
		func(card: Card)-> int:
			return card.rarity == with_rarity)
	
	return all_possible_cards.pick_random()


func _on_card_reward_taken(card: Card) -> void:
	if !card: return
	
	print("Drafted %s" % card.name)
	Data.character.deck.add_card(card)


func _on_gold_reward_taken(amount: int) -> void:
	if ! Data:
		return
	
	Data.gold += amount


func _on_back_button_pressed() -> void:
	Events.battle_reward_exited.emit()
