class_name CardTooltip
extends Control

@onready var tooltip_background: PanelContainer = %TooltipBackground
@onready var card_description: RichTextLabel = %CardDescription


func show_tooltip(card: Card) -> void:
	card_description.text = card.effect_description
	modulate.a = 1
	z_index = 2
	# Corrects tooltip position as to not go off screen
	tooltip_background.position.x = 48
	if global_position.x > 200: tooltip_background.position.x -= (tooltip_background.size.x + 50)
