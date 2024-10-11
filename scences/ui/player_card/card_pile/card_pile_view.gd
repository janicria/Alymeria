class_name CardPileView
extends Control

const CARD_MENU_UI_SCENCE := preload("res://scences/ui/player_card/card_menu_ui.tscn")

@export var card_pile : CardPile : set = set_card_pile

@onready var title: Label = %Title
@onready var cards: GridContainer = %Cards
@onready var return_button: Button = %ReturnButton
@onready var card_tooltip: CardTooltip = %CardTooltip

var shuffled_cards: Array[Card]
var current_view_randomised := false
var open := false


func _ready() -> void:
	Events.update_card_tooltip_position.connect(_on_update_card_tooltip_position)
	
	return_button.pressed.connect(func()->void:
		hide(); GameManager.card_pile_open = false; open = false)

	for card: Node in cards.get_children(): card.queue_free()
	
	card_tooltip.hide_tooltip()


func set_card_pile(value: CardPile) -> void:
	card_pile = value
	card_pile.card_pile_size_changed.connect(func(_cardpile_size: int)->void:
		# TODO: Fix for shuffled cards <- No ty, too hard
		if open: show_current_view(title.text, current_view_randomised))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hide()
		GameManager.card_pile_open = false
		open = false


func show_current_view(new_title : String, randomised := false) -> void:
	GameManager.card_pile_open = true
	open = true
	
	for card: Node in cards.get_children(): card.hide(); card.queue_free()
	
	card_tooltip.hide_tooltip()
	title.text = new_title
	_update_view.call_deferred(randomised)


func _update_view(randomised: bool) -> void:
	if ! card_pile: return
	current_view_randomised = randomised
	
	var all_cards := card_pile.cards.duplicate()
	if randomised: all_cards.shuffle(); shuffled_cards = all_cards
	
	for card: Card in all_cards:
		var new_card := CARD_MENU_UI_SCENCE.instantiate() as CardMenuUI
		cards.add_child(new_card)
		new_card.card = card
		new_card.card_tooltip_requested.connect(card_tooltip.show_tooltip)
		if get_name() == "CachePileView": new_card.show_cache_cost()
	
	show()


func _on_update_card_tooltip_position(card : CardMenuUI) -> void:
	card_tooltip.position = card.get_screen_position()
	card_tooltip.hitbox.position.x = 5
	if card_tooltip.position.x > 260:
		card_tooltip.position.x = 150
		card_tooltip.hitbox.position.x = 120
