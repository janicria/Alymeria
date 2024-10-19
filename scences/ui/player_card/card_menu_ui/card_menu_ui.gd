class_name CardMenuUI
extends CenterContainer

signal card_tooltip_requested(card : Card)

const BASE_STYLEBOX := preload("res://scences/ui/player_card/card_ui/card_base_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scences/ui/player_card/card_ui/card_hover_stylebox.tres")

@export var card: Card : set = set_card

@onready var panel: Panel = %Panel
@onready var cost: Label = %Cost
@onready var type: Label = %Type
@onready var icon: TextureRect = %Icon
@onready var desc: Label = %Desc
@onready var _name: Label = %Name
@onready var cache_cost: RichTextLabel = %CacheCost
@onready var card_tooltip: CardTooltip = %CardTooltip


# It doesn't matter if cache cost can't hide as card menu uis are instanced whenever a card pile is opened
func show_cache_cost() -> void:
	card.set_cache_cost(0)
	cache_cost.text = "[center][color=D9BB26]%s[/color][/center]" % card.cache_cost
	cache_cost.show()


# TODO: Connect with CardUI
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
	desc.text = card.get_tooltip_text(null, null)
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


func _on_tooltip_mouse_entered() -> void:
	panel.set("theme_override_styles/panel", HOVER_STYLEBOX)
	card_tooltip.show_tooltip(card)


func _on_tooltip_mouse_exited() -> void:
	panel.set("theme_override_styles/panel", BASE_STYLEBOX)
	card_tooltip.modulate.a = 0
