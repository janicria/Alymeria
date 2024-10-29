class_name CardPile extends Resource

signal card_pile_size_changed(cards_amount: int)

@export var cards : Array[Card] = []


func empty() -> bool:
	return cards.is_empty()


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
