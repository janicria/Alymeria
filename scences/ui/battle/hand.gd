class_name Hand
extends HBoxContainer

@export var player: Player

@onready var card_ui := preload("res://scences/card_ui/card_ui.tscn")

func _ready() -> void:
	Events.update_card_variant.connect(update_card_variant)
	child_order_changed.connect(update_card_seperation)

func add_card(card : Card) -> void:
	var new_card_ui := card_ui.instantiate() as CardUI
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.playable = GameManager.character.can_play_card(new_card_ui.card)
	new_card_ui.parent = self
	new_card_ui.player_modifiers = player.modifier_handler


func discard_card(card : CardUI) -> void:
	card.queue_free()


func disable_hand() -> void:
	for card in get_children():
		card.disabled = true


func update_card_seperation() -> void:
	if get_child_count() < 6: add_theme_constant_override("separation", 8)
	match get_child_count():
		6: add_theme_constant_override("separation", -1)
		7: add_theme_constant_override("separation", -5)
		8: add_theme_constant_override("separation", -10)
		9: add_theme_constant_override("separation", -14)
		10: add_theme_constant_override("separation", -18)


func update_card_variant(variant: String, value, set_cardui: bool) -> void:
	for cardui: CardUI in get_children():
		if cardui:
			var old_value = cardui.get(variant)
			cardui.set(variant, (old_value + value))
			cardui.set_card(cardui.card)
			cardui.playable = GameManager.character.can_play_card(cardui.card)
		else:
			var old_value = cardui.card.get(variant)
			cardui.card.set(variant, (old_value + value))
			cardui.set_card(cardui.card)
			cardui.playable = GameManager.character.can_play_card(cardui.card)


func _on_card_ui_reparent_requested(child : CardUI) -> void:
	child.disabled = true
	child.reparent(self)
	var new_index := clampi(child.original_index, 0, get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)
