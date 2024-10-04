class_name PlayerHandeler
extends Node

const HAND_DRAW_INTERVAL := 0.25
const HAND_DISCARD_INTERVAL := 0.25

@export var player: Player
@export var hand: Hand


func _ready() -> void:
	Events.card_played.connect(_on_card_played)
	Events.player_draw_cards.connect(draw_cards)


func start_battle(character : CharacterStats) -> void:
	GameManager.character = GameManager.character
	GameManager.character.draw_pile = GameManager.character.deck.duplicate(true)
	GameManager.character.draw_pile.shuffle()
	GameManager.character.discard = CardPile.new()
	player.status_handler.statuses_applied.connect(_on_statuses_applied)


func start_turn() -> void:
	GameManager.character.barrier = clamp(GameManager.character.barrier -10, 0, 999)
	GameManager.character.reset_mana()
	player.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)


func end_turn() -> void:
	hand.disable_hand()
	player.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)


func draw_card() -> void:
	reshuffle_deck_from_discard()
	if !GameManager.character.draw_pile.cards: return
	hand.add_card(GameManager.character.draw_pile.draw_card())
	reshuffle_deck_from_discard()
	Events.update_card_stats.emit()


# TODO Add tween animation for reshuffling discard into draw
func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in amount:
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
		tween.finished.connect(
			func()->void:
				# Prevents cards from being placed after being draw in between updating mana
				GameManager.character.set_mana(GameManager.character.mana)
				Events.player_hand_drawn.emit()
				Events.update_card_stats.emit())


func discard_cards() -> void:
	# Prevents tween from failing to run with an empty hand
	if hand.get_child_count() == 0:
		Events.player_hand_discarded.emit()
		return
	
	var tween := create_tween()
	for card_ui in hand.get_children():
		tween.tween_callback(GameManager.character.discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	tween.finished.connect(func()->void: Events.player_hand_discarded.emit())


func reshuffle_deck_from_discard() -> void:
	if !GameManager.character.draw_pile.empty():
		return
	
	while !GameManager.character.discard.empty():
		GameManager.character.draw_pile.add_card(GameManager.character.discard.draw_card())
	
	GameManager.character.draw_pile.shuffle()


func _on_card_played(card : Card) -> void:
	if card.exhausts: GameManager.character.exhaust_pile.add_card(card)
	else: GameManager.character.discard.add_card(card)


func _on_statuses_applied(type: Status.Type) -> void:
	match type:
		Status.Type.START_OF_TURN: draw_cards(GameManager.character.cards_per_turn)
		Status.Type.END_OF_TURN: discard_cards()
