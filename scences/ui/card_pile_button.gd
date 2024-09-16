class_name CardPileButton
extends TextureButton

@export var counter : Label
@export var card_pile : CardPile : set = set_card_pile

@onready var color_rect: ColorRect = $ColorRect

var deck_size := 0
var exhausts_in_deck := 0

func set_card_pile(new_value : CardPile) -> void:
	card_pile = new_value
	
	Events.update_deck_buttons.connect(update_ui)
	Events.update_deck_counter.connect(
		func()->void:
			update_ui(exhausts_in_deck, true)
	)
	
	if !card_pile.card_pile_size_changed.is_connected(_on_card_pile_size_changed):
		card_pile.card_pile_size_changed.connect(_on_card_pile_size_changed)
		_on_card_pile_size_changed(card_pile.cards.size())
	
	update_ui(deck_size, true)


func _on_card_pile_size_changed(cards_amount : int) -> void:
	counter.text = str(cards_amount)
	deck_size = cards_amount
	if GameSave.true_deck_size:
		Events.update_deck_buttons.emit(0, false)


func update_ui(amount : int, returning : bool) -> void:
	if returning:
		exhausts_in_deck = amount
	
	if GameSave.true_deck_size and get_name() == "DeckButton":
		counter.text = str(deck_size) + " (" + str(deck_size - exhausts_in_deck) + ")"
	else:
		counter.text = str(deck_size)
	
	if get_name() == "DrawPileButton":
		if GameSave.card_pile_above_mana:
			position = Vector2(58, 145)
		else:
			position = Vector2(80, 170)
	if get_name() == "DiscardPileButton":
		if GameSave.card_pile_above_mana:
			position = Vector2(38, 145)
		else:
			position = Vector2(317, 170)


func _on_mouse_entered() -> void:
	color_rect.color.a = 0.18


func _on_mouse_exited() -> void:
	color_rect.color.a = 0
