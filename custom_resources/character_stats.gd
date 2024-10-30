class_name CharacterStats extends Stats

@export_group("Visuals")
@export var character_name : String
@export_multiline var description : String
@export var portrait: Texture

@export_group("Gameplay Data")
@export var starting_deck: CardPile
@export var starting_core: Resource
@export var card_pool: CardPile
@export var cards_per_turn : int
@export var max_mana : int
@export var mana_type : String

var mana: int : set = set_mana
var cache_tokens: int : set = set_cache
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile
var exhaust_pile: CardPile
var cache_pile: CardPile


func set_cache(value: int) -> void:
	cache_tokens = clampi(value, 0, 99)
	Events.update_deck_button_ui.emit()


func set_mana(value : int) -> void:
	mana = clampi(value, 0, 99)
	stats_changed.emit()


func reset_mana() -> void:
	mana = max_mana


func take_damage(damage : int) -> void:
	var initial_health := health
	super.take_damage(damage)
	if initial_health > health: 
		Data.damage_taken += damage
		Events.player_hit.emit()


func can_play_card(card : Card) -> bool:
	return mana >= card.cost


func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.barrier = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	instance.exhaust_pile = CardPile.new()
	instance.cache_pile = CardPile.new()
	instance.player = true
	return instance
