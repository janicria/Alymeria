class_name CardPile extends Resource

signal card_pile_size_changed(cards_amount: int)

@export var cards : Array[Card] = []


static func generate_from_ui(cardui_array: Array[Node]) -> CardPile:
	var card_pile_to_send := CardPile.new()
	for cardui: CardUI in cardui_array:
		cardui.card.cardui = cardui
		card_pile_to_send.add_card(cardui.card)
	return card_pile_to_send


# Erase doesn't take id into consideration, idk why
func erase_card_with_id(id: int) -> void:
	var i := 0 # Prevents warning
	for card in cards:
		i += 1
		if card.unique_id == id:
			cards.remove_at(i)
			return


func draw_card() -> Card:
	var card: Card = cards.pop_front()
	card_pile_size_changed.emit(cards.size())
	return card


func add_card(card: Card) -> void:
	cards.append(card)
	card_pile_size_changed.emit(cards.size())


func has_card(card_to_check: Card) -> bool:
	for card in cards: 
		if card == card_to_check:
			return true
	return false


func remove_card(card: Card) -> void:
	cards.erase(card)
	card_pile_size_changed.emit(cards.size())


# Only called for draw pile
func shuffle() -> Array[Card]:
	cards.shuffle()
	
	for card in cards:
		if card.has_status("heavy"):
			cards.erase(card)
			cards.append(card)
	return cards


func clear() -> void:
	cards.clear()
	card_pile_size_changed.emit(cards.size())


func show_cards() -> Array[Card]:
	return cards


func duplicate_cards() -> Array[Card]:
	var new_array: Array[Card] = []
	
	for card: Card in cards:
		new_array.append(card.duplicate())
	
	return new_array
