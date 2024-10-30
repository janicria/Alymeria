class_name CardPileView extends Control

signal card_selected(card: Card)

const CARD_MENU_UI_SCENCE := preload("res://scences/ui/player_card/card_menu_ui/card_menu_ui.tscn")

@export var card_pile : CardPile : set = set_card_pile

@onready var title: Label = %Title
@onready var cards: GridContainer = %Cards
@onready var return_button: Button = %ReturnButton

var shuffled_cards: Array[Card]
var current_view_randomised := false
var open := false


static func generate_cardpile_from_ui(cardui_array: Array[Node]) -> CardPile:
	var card_pile_to_send := CardPile.new()
	for cardui in cardui_array:
		card_pile_to_send.add_card(cardui.card)
	return card_pile_to_send


func _ready() -> void:
	return_button.pressed.connect(_hide)
	
	# Clears old cards
	for card: Node in cards.get_children(): 
		card.queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): _hide()


func set_card_pile(value: CardPile) -> void:
	card_pile = value
	card_pile.card_pile_size_changed.connect(func(_size: int)->void:
		# TODO: Fix for shuffled cards <- No ty, too hard
		if open: show_current_view(title.text, current_view_randomised))


func select_card() -> void:
	Data.player_handler.hand.toggle_hand_state(true)
	return_button.visible = title.text == "Select a card to uncache"
	for cardmenu: CardMenuUI in cards.get_children():
		cardmenu.card_tooltip.gui_input.connect(
			func(input: InputEvent)-> void:
				if input.is_action_pressed("left_mouse"):
					card_selected.emit(cardmenu.card))


func _hide() -> void:
	hide()
	Data.card_pile_open = false
	open = false
	if Data.player_handler != null: # In case a battle hasn't started yet
		Data.player_handler.hand.toggle_hand_state(false)


func show_current_view(new_title : String, randomised := false) -> void:
	Data.card_pile_open = true
	open = true
	
	for card: Node in cards.get_children(): 
		card.hide()
		card.queue_free()
	
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
		if get_name() == "CachePileView": new_card.show_cache_cost()
	
	show()
