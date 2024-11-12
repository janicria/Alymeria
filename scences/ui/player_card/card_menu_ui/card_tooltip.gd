class_name CardTooltip extends Control

@onready var tooltip_background: PanelContainer = %TooltipBackground
@onready var card_description: RichTextLabel = %CardDescription

const OFFSET := 99

func show_tooltip(card: Card) -> void:
	card_description.text = "[center][font_size=12]"
	for effect in card.effects:
		card_description.text += Data.StatusDescriptions.get(effect) + (
			"[/font_size][/center]" if effect == card.effects[-1] else "\n")
	modulate.a = 1
	z_index = 2
	# Corrects tooltip position as to not go off screen
	tooltip_background.position.x = OFFSET
	if global_position.x > 400: tooltip_background.position.x -= (tooltip_background.size.x + (OFFSET*1.05))
