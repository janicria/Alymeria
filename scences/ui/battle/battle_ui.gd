class_name BattleUI extends CanvasLayer

@onready var hand: Hand = $Hand
@onready var memory_ui: MemoryUI = $MemoryUI
@onready var end_turn_button: Button = %EndTurnButton
@onready var draw_pile_button: CardPileButton = %DrawPileButton
@onready var discard_pile_button: CardPileButton = %DiscardPileButton
@onready var cache_pile_button: CardPileButton = %CachePileButton
@onready var exhaust_pile_button: CardPileButton = %ExhaustPileButton
@onready var draw_pile_view: CardPileView = %DrawPileView
@onready var discard_pile_view: CardPileView = %DiscardPileView
@onready var exhaust_pile_view: CardPileView = %ExhaustPileView
@onready var cache_pile_view: CardPileView = %CachePileView
@onready var custom_pile_view: CardPileView = %CustomPileView
@onready var turn_counter: Label = %TurnCounter


func _ready() -> void:
	Data.battle_ui = self
	Events.player_hand_drawn.connect(func()->void: end_turn_button.disabled = false)
	Events.update_turn_number.connect(func(number:int)->void: turn_counter.text = str(number))
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	draw_pile_button.pressed.connect(draw_pile_view.show_current_view.bind("Draw pile", true))
	discard_pile_button.pressed.connect(discard_pile_view.show_current_view.bind("Discard pile"))
	exhaust_pile_button.pressed.connect(exhaust_pile_view.show_current_view.bind("Exhaust pile"))
	cache_pile_button.pressed.connect(cache_pile_view.show_current_view.bind("Cache pile"))


func initialise_card_pile_ui() -> void:
	draw_pile_button.card_pile = Data.character.draw_pile
	discard_pile_button.card_pile = Data.character.discard
	exhaust_pile_button.card_pile = Data.character.exhaust_pile
	cache_pile_button.card_pile = Data.character.cache_pile
	discard_pile_view.card_pile = Data.character.discard
	draw_pile_view.card_pile = Data.character.draw_pile
	exhaust_pile_view.card_pile = Data.character.exhaust_pile
	cache_pile_view.card_pile = Data.character.cache_pile


func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.update_battle_state.emit(Battle.State.ENEMY_CARDS)
