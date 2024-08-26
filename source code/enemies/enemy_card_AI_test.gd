extends Node

signal health_below_8

@export var enemy: Enemy
@export var ai: String

var cards_per_turn := 3
var max_mana := 2

enum Moveset {PINCH, HIDE, FORTIFY}
enum Abilities {ATTACK, BARRIER} #Pretend this comes from the main class

@onready var cards: Control = $Cards
@onready var card_template: Control = %CardTemplate

# ID, Weight, Cost, Type, Amount, Repeats, Signals, Deck size
var ability_stats := {
	Moveset.PINCH: ["pinch", 1, 1, Abilities.ATTACK, 5, 1, null, 3],
	Moveset.FORTIFY: ["fortify", 1, 1, Abilities.BARRIER, 6, 1, null, 2],
	Moveset.HIDE: ["hide", 0, 2, Abilities.BARRIER, 15, 1, health_below_8, 1]
}
var deck: Array[Array]
var discard: Array[Array]
var mana := max_mana
var cards_this_turn: Array[Array] = []
var cards_left := cards_per_turn

func _ready() -> void:
	load_stats()


func load_stats() -> void:
	for i in Moveset.size():
		var current_card: Array = ability_stats.get(i) as Array
		for size in current_card.back():
			deck.append(current_card)
	
	deck.shuffle()
	get_turn_cards()
	
	if enemy:
		self.position = Vector2(185, 5)
		print(self.position)
		ai = enemy.stats.id
		print(ai)


func get_turn_cards() -> void:
	mana = max_mana
	cards_left = cards_per_turn
	for ability in cards_per_turn:
		if deck.size():
			add_card()
		else:
			print("shuffling deck")
			deck.append_array(discard)
			discard.clear()
			deck.shuffle()
			add_card()


func add_card() -> void:
	var card: Array = deck.pop_front() as Array
	discard.append(card)
	cards_this_turn.append(card)
	cards_left -= 1
	
	if !cards_left:
		play_cards()


func play_cards() -> void:
	for i in cards_this_turn.size():
		var card: Array = cards_this_turn.pop_front() as Array
		var card_ui = card_template.duplicate() as Control
		load_card_ui(card_ui, card, true)
		print("played card %s " % str(card))
		mana -= 1
		if !mana:
			var fake_card: Array = cards_this_turn.pop_front() as Array
			var fake_card_ui = card_template.duplicate() as Control
			cards_this_turn.append(fake_card)
			load_card_ui(fake_card_ui, fake_card, false)
			print("ran out of mana, unable to play %s" % str(cards_this_turn))
			return


func load_card_ui(card_ui: Control, card_stats: Array, playable: bool) -> void:
	cards.add_child(card_ui)
	card_ui.get_child(1).text = str(card_stats.pop_at(1))
	card_ui.get_child(2).text = str(card_stats.pop_at(0))
	card_ui.visible = true
	if playable:
		card_ui.modulate.a = 0.9
	else:
		card_ui.modulate.a = 0.6
