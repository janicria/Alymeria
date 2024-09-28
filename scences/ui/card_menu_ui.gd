class_name CardMenuUI
extends CenterContainer

signal card_tooltip_requested(card : Card)

const BASE_STYLEBOX := preload("res://scences/card_ui/card_base_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scences/card_ui/card_hover_stylebox.tres")

@export var card: Card : set = set_card

@onready var panel: Panel = $Visuals/Panel
@onready var cost: Label = $Visuals/Cost
@onready var type: Label = $Visuals/Type
@onready var icon: TextureRect = $Visuals/Icon
@onready var desc: Label = $Visuals/Desc
@onready var _name: Label = $Visuals/Name


var description := ''

# Not actually a copy from CardUI's method with the same name, the two just look very similar <- # HACK: yes it is wtf are you yapping about
func set_card(value : Card) -> void:
	if ! is_node_ready():
		await ready
	
	card = value
	
	match card.rarity:
		0: type.modulate = Color(Color.GRAY)
		1: type.modulate = Color(Color.CORNFLOWER_BLUE)
		2: type.modulate = Color(Color.GOLD)
		3: type.modulate = Color(Color.DARK_RED)
	
	_name.modulate = type.modulate
	cost.text = str(card.cost)
	desc.text = card.tooltip_text
	_name.text = card.name
	
	
	match card.type:
		0: type.text = " -Physical" 
		1: type.text = " -Internal"
		2:
			if GameManager.character.character_name == "Machine":
				type.text = "  -Looped"
			elif GameManager.character.character_name == "Witch":
				type.text = " -Summon"
		3: type.text = " -Status"
		4:
			if GameManager.character.character_name == "Machine":
				type.text = " -Malware"
			elif GameManager.character.character_name == "Witch":
				type.text = " -Hex"
	
	# Prevents card names from going out of its area/hitbox
	if _name.get_line_count() > 1:
		cost.position.y = cost.position.y + (_name.get_line_count() * _name.get_line_height()) -5
		type.position.y = cost.position.y
		desc.position.y = desc.position.y + (_name.get_line_count() * _name.get_line_height()) -5


func _on_visuals_mouse_entered() -> void:
	panel.set("theme_override_styles/panel", HOVER_STYLEBOX)
	card_tooltip_requested.emit(card)
	Events.update_card_tooltip_position.emit(self)


func _on_visuals_mouse_exited() -> void:
	panel.set("theme_override_styles/panel", BASE_STYLEBOX)
