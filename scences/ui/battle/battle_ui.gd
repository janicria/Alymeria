class_name BattleUI
extends CanvasLayer


@onready var hand: Hand = $Hand
@onready var mana_ui: ManaUI = $ManaUI
@onready var end_turn_button: Button = %EndTurnButton
@onready var draw_pile_button: CardPileButton = %DrawPileButton
@onready var discard_pile_button: CardPileButton = %DiscardPileButton
@onready var draw_pile_view: CardPileView = %DrawPileView
@onready var exhaust_pile_button: CardPileButton = %ExhaustPileButton
@onready var discard_pile_view: CardPileView = %DiscardPileView
@onready var exhaust_pile_view: CardPileView = %ExhaustPileView


func _ready() -> void:
	Events.player_hand_drawn.connect(func()->void: end_turn_button.disabled = false)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	draw_pile_button.pressed.connect(draw_pile_view.show_current_view.bind("Draw pile", true))
	discard_pile_button.pressed.connect(discard_pile_view.show_current_view.bind("Discard pile"))
	exhaust_pile_button.pressed.connect(exhaust_pile_view.show_current_view.bind("Exhaust pile"))


func initialise_card_pile_ui() -> void:
	draw_pile_button.card_pile = GameManager.character.draw_pile
	discard_pile_button.card_pile = GameManager.character.discard
	exhaust_pile_button.card_pile = GameManager.character.exhaust_pile
	discard_pile_view.card_pile = GameManager.character.discard
	draw_pile_view.card_pile = GameManager.character.draw_pile
	exhaust_pile_view.card_pile = GameManager.character.exhaust_pile


func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.battle_state_updated.emit(4)
