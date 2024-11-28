class_name CharacterStats extends Stats

@export_group("Gameplay Data")
@export var starting_deck: CardPile
@export var starting_core: Core
@export var card_pool: CardPile
@export var cards_per_turn: int
@export var max_memory: int

var memory: int : set = set_memory
var cache_tokens: int : set = set_cache
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile
var exhaust_pile: CardPile
var cache_pile: CardPile


func set_cache(value: int) -> void:
	cache_tokens = clampi(value, 0, 99)
	Events.update_deck_button_ui.emit()


func set_memory(value : int) -> void:
	memory = clampi(value, 0, 99)
	stats_changed.emit()


func take_damage(damage: int, status: Status = null) -> bool:
	var initial_health := health
	var result := super.take_damage(damage)
	if initial_health > health:
		Data.damage_taken += damage
		if status != null:
			var status_effect := StatusEffect.new()
			status_effect.status = status
			status_effect.execute([Data.player_handler.player])
		Events.player_hit.emit()
	return result


func can_play_card(card : Card) -> bool:
	return memory >= card.cost


func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.barrier = 0
	instance.memory = instance.max_memory
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	instance.exhaust_pile = CardPile.new()
	instance.cache_pile = CardPile.new()
	instance.is_player = true
	return instance
