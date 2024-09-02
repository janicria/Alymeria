class_name BattleReward
extends Control

const CARD_REWARDS := preload("res://scences/ui/card_rewards.tscn")
const REWARD_BUTTON := preload("res://scences/ui/reward_button.tscn")
const GOLD_ICON := preload("res://assets/art/gold.png")
const GOLD_TEXT := "%s gold"
const CARD_ICON := preload("res://assets/art/rarity.png")
const CARD_TEXT := "Add a New Card"
const REGULAR_POTION_ICON := preload("res://assets/art/tile_0114.png")
#const POTION_TEXT := ""

#@export var GameSave: RunStats
@export var character_stats: CharacterStats

@onready var rewards: VBoxContainer = %Rewards

var card_reward_total_weight := 0.0
var card_rarity_weights := {
	Card.Rarity.RARE: 0.0,
	Card.Rarity.UNCOMMON: 0.0,
	Card.Rarity.COMMON: 0.0
}


func _ready() -> void:
	character_stats = GameSave.character
	
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
	for i in GameSave.card_rewards:
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


	# Don't think this is needed anymore, if it
	# still hasn't ever ran by the end of Alpha
	# development then remove it
	while card_reward_array.size() < 4:
		for i in (4 - card_reward_array.size()):
			setup_card_rarity_chances()
			var roll := randf_range(0.0, card_reward_total_weight)
			
			for rarity: Card.Rarity in card_rarity_weights:
				if card_rarity_weights[rarity] > roll:
					_modify_weights(rarity)
					var picked_card := _get_random_available_card(available_cards, rarity)
					card_reward_array.append(picked_card)
					available_cards.erase(picked_card)
					print("Error selecting card, hotfix selected %s" % picked_card)
					break
	
	card_rewards.rewards = card_reward_array
	card_rewards.show()



func setup_card_rarity_chances() -> void:
	card_reward_total_weight = GameSave.common_weight + GameSave.uncommon_weight + GameSave.rare_weight
	card_rarity_weights[Card.Rarity.COMMON] = GameSave.common_weight
	card_rarity_weights[Card.Rarity.UNCOMMON] = GameSave.uncommon_weight
	card_rarity_weights[Card.Rarity.RARE] = GameSave.rare_weight
	var biome := 0 # TODO replace w/ GameSave.biome
	if biome:
		card_rarity_weights[Card.Rarity.UNCOMMON] *= (biome * 2)
		card_rarity_weights[Card.Rarity.RARE] += biome


# Increments rare weights over time (reuse for pot chances)
# TODO change for elites and boss combat rewards
func _modify_weights(rarity_rolled: Card.Rarity) -> void:
	if rarity_rolled == Card.Rarity.UNCOMMON:
		GameSave.common_weight = RunStats.BASE_COMMON_WEIGHT - GameSave.rare_weight
		GameSave.uncommon_weight = GameSave.BASE_UNCOMMON_WEIGHT
	else:
		GameSave.uncommon_weight = clampf(GameSave.uncommon_weight + 8.0, GameSave.BASE_UNCOMMON_WEIGHT, 80.0)
		GameSave.common_weight = GameSave.BASE_COMMON_WEIGHT - GameSave.uncommon_weight
	
	if rarity_rolled == Card.Rarity.RARE:
		GameSave.rare_weight = RunStats.BASE_RARE_WEIGHT
		GameSave.common_weight = RunStats.BASE_COMMON_WEIGHT
		GameSave.uncommon_weight = RunStats.BASE_UNCOMMON_WEIGHT
	else:
		GameSave.rare_weight = clampf(GameSave.rare_weight + 4.0, GameSave.BASE_RARE_WEIGHT, 50.0)
		GameSave.common_weight = GameSave.BASE_COMMON_WEIGHT - GameSave.rare_weight
	
	while card_reward_total_weight > 100:
		GameSave.common_weight -= 1
		setup_card_rarity_chances()
	while card_reward_total_weight < 100:
		GameSave.common_weight += 1
		setup_card_rarity_chances()


# Ensures that you get a card that has the rarity
# which was rolled by _show_card_rewards()
func _get_random_available_card(available_cards: Array[Card], with_rarity: Card.Rarity) -> Card:
	var all_possible_cards := available_cards.filter(
		func(card: Card):
			return card.rarity == with_rarity
	)
	return all_possible_cards.pick_random()


func _on_card_reward_taken(card: Card) -> void:
	if !character_stats or !card:
		return
	
	print(character_stats.description)
	print(GameSave.character.description)
	print("drafted %s" % card.id)
	#character_stats.deck.add_card(card)
	GameSave.character.deck.add_card(card)


func _on_gold_reward_taken(amount: int) -> void:
	if ! GameSave:
		return
	
	GameSave.gold += amount


func _on_back_button_pressed() -> void:
	Events.battle_reward_exited.emit()
