extends Node

@onready var cards: HBoxContainer = $Cards
@onready var card_template: Control = %CardTemplate


func _ready() -> void:
	Events.enemy_add_card.connect(add_card)


func add_card(card_stats: EnemyCard) -> void:
	var card_ui := card_template.duplicate()
	cards.add_child(card_ui)
	card_ui.get_child(1).text = card_stats.cost
	card_ui.get_child(2).text


func load_card_ui(card_ui: Control, card_stats: Array, playable: bool) -> void:
	cards.add_child(card_ui)
	card_ui.get_child(1).text = str(card_stats.pop_at(1))
	card_ui.get_child(2).text = str(card_stats.pop_at(0))
	card_ui.visible = true
	if playable:
		card_ui.modulate.a = 0.9
	else:
		card_ui.modulate.a = 0.6
