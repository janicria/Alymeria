class_name CardRewards
extends ColorRect

signal card_reward_selected(card: Card)

const CARD_MENU_UI := preload("res://scences/ui/player_card/card_menu_ui.tscn")

@export var rewards: Array[Card] : set = set_rewards

@onready var cards: HBoxContainer = %Cards
@onready var skip_button: Button = %SkipButton
@onready var card_tooltip: CardTooltip = $CardTooltip

var selected_card: Card

func _ready() -> void:
	_clear_rewards()
	
	Events.update_card_tooltip_position.connect(_on_update_card_tooltip_position)
	
	card_tooltip.hitbox.gui_input.connect(
		func(input: InputEvent)-> void:
			if input.is_action_pressed("left_mouse_pressed"):
				card_reward_selected.emit(selected_card)
				# Stops game from crashing without an error (idk why)
				get_parent().remove_child(self)
				queue_free())
	
	skip_button.pressed.connect(func() -> void:
			card_reward_selected.emit(null)
			queue_free())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		card_tooltip.hide_tooltip()


func _clear_rewards() -> void:
	for card: Node in cards.get_children():
		card.queue_free()
	
	card_tooltip.hide_tooltip()
	
	selected_card = null


func _show_tooltip(card: Card) -> void:
	selected_card = card
	card_tooltip.show_tooltip(card)


func set_rewards(new_cards: Array[Card]) -> void:
	rewards = new_cards
	
	if !is_node_ready():
		await ready
	
	_clear_rewards()
	
	for card: Card in rewards:
		var new_card := CARD_MENU_UI.instantiate() as CardMenuUI
		cards.add_child(new_card)
		new_card.card = card
		new_card.card_tooltip_requested.connect(_show_tooltip)


func _on_update_card_tooltip_position(card : CardMenuUI) -> void:
	card_tooltip.position = card.get_screen_position()
	card_tooltip.hitbox.position.x = 0
	if card_tooltip.position.x > 200:
		card_tooltip.position.x = 100
		card_tooltip.hitbox.position.x = 128
