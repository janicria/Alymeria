class_name CardPileView
extends Control

const CARD_MENU_UI_SCENCE := preload("res://scences/ui/card_menu_ui.tscn")

@export var card_pile : CardPile

@onready var title: Label = %Title
@onready var cards: GridContainer = %Cards
@onready var return_button: Button = %ReturnButton
@onready var card_tooltip: CardTooltip = %CardTooltip


func _ready() -> void:
	Events.update_card_tooltip_position.connect(_on_update_card_tooltip_position)
	Events.update_deck_buttons.connect(_on_update_deck_buttons)
	
	return_button.pressed.connect(hide)
	
	for card: Node in cards.get_children():
		card.queue_free()
	
	card_tooltip.hide_tooltip()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hide()


func show_current_view(new_title : String, randomized : bool = false) -> void:
	for card: Node in cards.get_children():
		card.queue_free()
	
	card_tooltip.hide_tooltip()
	title.text = new_title
	_update_view.call_deferred(randomized)



func _update_view(randomized : bool) -> void:
	if ! card_pile:
		return
	
	var all_cards := card_pile.cards.duplicate()
	if randomized:
		all_cards.shuffle()
	
	for card: Card in all_cards:
		var new_card := CARD_MENU_UI_SCENCE.instantiate() as CardMenuUI
		cards.add_child(new_card)
		new_card.card = card
		new_card.card_tooltip_requested.connect(card_tooltip.show_tooltip)
		print()
	
	show()


func _on_update_card_tooltip_position(card : CardMenuUI) -> void:
	card_tooltip.position = card.get_screen_position()
	card_tooltip.hitbox.position.x = 5
	if card_tooltip.position.x > 260:
		card_tooltip.position.x = 150
		card_tooltip.hitbox.position.x = 120


func _on_update_deck_buttons(amount : int, returning : bool):
	if returning:
		return
	
	Events.update_deck_buttons.emit(cards.get_child_count(), true)
