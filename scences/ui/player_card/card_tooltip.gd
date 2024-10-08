class_name CardTooltip
extends Control

const CARD_MENU_UI_SCENCE := preload("res://scences/ui/player_card/card_menu_ui.tscn")

@onready var card_description: RichTextLabel = %CardDescription
@onready var hitbox: Control = $Hitbox

func show_tooltip(card : Card) -> void:
	var new_card := CARD_MENU_UI_SCENCE.instantiate() as CardMenuUI
	add_child(new_card)
	new_card.hide()
	new_card.card = card
	new_card.card_tooltip_requested.connect(hide_tooltip.unbind(1))
	card_description.text = card.effect_description
	
	show()


func hide_tooltip() -> void:
	if !visible:
		return
	
	hide()


func _on_hitbox_mouse_exited() -> void:
	hide_tooltip()
