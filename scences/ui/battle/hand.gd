class_name Hand
extends HBoxContainer

@export var player: Player

@onready var CARDUI := preload("res://scences/ui/player_card/card_ui/cardui.tscn")


func _ready() -> void:
	Events.update_card_variant.connect(update_card_variant)
	child_order_changed.connect(update_card_seperation)
	Events.update_hand_state.connect(check_for_cancel)
	Events.player_hand_drawn.connect(check_for_cancel)


# TODO: Mention playing cards before start of turn cores being a feature
func check_for_cancel() -> void:
	if player.status_handler._get_status("cancel"): 
		for child: CardUI in get_children():
			child.canceled = true
			child.playable = false
			child.disabled = true


func add_card(card: Card) -> void:
	# Needed for uncaching cards
	if get_child_count() >= 10: OS.alert("Max hand size is 10"); return
	var new_card_ui := CARDUI.instantiate() as CardUI
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.parent = self
	# In case the player dies whilst drawing cards
	var wr: WeakRef = weakref(player); if !wr.get_ref(): return
	new_card_ui.player_modifiers = player.modifier_handler
	new_card_ui.card = card
	# DO NOT REMOVE THE BELOW LINE
	new_card_ui.card.cardui = new_card_ui
	# DO NOT REMOVE THE ABOVE LINE
	new_card_ui.playable = Data.character.can_play_card(new_card_ui.card)
	Events.player_card_drawn.emit()
	new_card_ui.card.drawn()
	if player.status_handler._get_status("cancel"): new_card_ui.canceled = true; new_card_ui.playable = false


func discard_card(cardui: CardUI) -> void:
	if (!Data.character.cache_pile.cards.has(cardui.card) 
	&& !cardui.card.has_status("burn") 
	&& !cardui.card.has_status("exhaust")): 
		Data.character.cache_pile.add_card(cardui.card)
	
	if cardui.card.has_status("burn") && Data.character.deck.has_card(cardui.card):
		Data.character.deck.remove_card(cardui.card)
	
	cardui.queue_free()


func toggle_hand_state(toggled_on: bool) -> void:
	for card in get_children(): card.disabled = toggled_on


func update_card_seperation() -> void:
	if get_child_count() < 6: add_theme_constant_override("separation", 11)
	match get_child_count():
		6: add_theme_constant_override("separation", -12)
		7: add_theme_constant_override("separation", -22)
		8: add_theme_constant_override("separation", -30)
		9: add_theme_constant_override("separation", -36)
		10: add_theme_constant_override("separation", -42)


func update_card_variant(variant: String, value: int) -> void:
	for cardui: CardUI in get_children():
		cardui.card.set(variant, (cardui.card.get(variant) + value))
		cardui.set_card(cardui.card)
		cardui.playable = Data.character.can_play_card(cardui.card)


# Called when a card is added back to hand from an aiming / dragging state
func _on_card_ui_reparent_requested(child : CardUI) -> void:
	child.disabled = true
	child.reparent(self)
	var new_index := clampi(child.original_index, 0, get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)
