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

func set_card(value : Card) -> void:
	if ! is_node_ready():
		await ready
	
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
	desc.text = card.tooltip_text
	description = card.effect_description
	_name.text = card.name
	card = value
	
	if !card.rarity:
		type.modulate = Color(Color.GRAY)
	elif card.rarity == 1:
		type.modulate = Color(Color.CORNFLOWER_BLUE)
	elif card.rarity == 2:
		type.modulate = Color(Color.GOLD)
	elif card.rarity == 3:
		type.modulate = Color(Color.DARK_RED)
	_name.modulate = type.modulate
	
	cost.text = str(card.cost)
	icon.texture = card.icon
	desc.text = card.tooltip_text
	_name.text = card.name
	
	if !card.type:
		type.text = " -Physical" 
	elif card.type == 1:
		type.text = " -Internal"
	elif card.type == 2:
		if GameSave.character.character_name == "Machine":
			type.text = "  -Looped"
		elif GameSave.character.character_name == "Machine":
			type.text = " -Summon"
	elif card.type == 3:
		type.text = " -Status"
	elif card.type == 4:
		if GameSave.character.character_name == "Machine":
			type.text = " -Malware"
		elif GameSave.character.character_name == "Machine":
			type.text = " -Hex"
	
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
