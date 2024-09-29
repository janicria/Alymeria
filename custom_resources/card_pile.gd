class_name CardPile
extends Resource

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


func remove_card(card: Card) -> void:
	cards.erase(card)
	card_pile_size_changed.emit(cards.size())


func shuffle() -> void:
	cards.shuffle()


func clear() -> void:
	cards.clear()
	card_pile_size_changed.emit(cards.size())


func _to_string() -> String:
	var _card_strings: PackedStringArray = []
	for i in range(cards.size()):
		_card_strings.append("%s: %s" % [i+1, cards[1].id])
		print(("%s: %s" % [i+1, cards[1].id]))
	return "\n".join(_card_strings)


func show_cards() -> Array[Card]:
	return cards


func duplicate_cards() -> Array[Card]:
	var new_array: Array[Card] = []
	
	for card: Card in cards:
		new_array.append(card.duplicate())
	
	return new_array
