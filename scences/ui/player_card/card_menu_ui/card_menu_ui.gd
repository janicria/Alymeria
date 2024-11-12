class_name CardMenuUI extends CenterContainer

signal show_tooltip(card: Card)

const STYLEBOX = preload("res://assets/styleboxes/default_stylebox.tres")
const HOVER_STYLEBOX = preload("res://assets/styleboxes/hover_stylebox.tres")

@export var card: Card : set = set_card

@onready var panel: Panel = %Panel
@onready var cost: Label = %Cost
@onready var type: Label = %Type
@onready var desc: RichTextLabel = %Desc
@onready var _name: Label = %Name
@onready var cache_cost: RichTextLabel = %CacheCost
@onready var card_statuses: VBoxContainer = %CardStatuses
@onready var card_tooltip: CardTooltip = %CardTooltip

var name_initialised := false


# TODO: Connect with CardUI
func set_card(value : Card) -> void:
	if !is_node_ready(): await ready
	card = value
	
	if !Events.update_draw_card_ui.is_connected(set_card):
		Events.update_draw_card_ui.connect(set_card.bind(card))
	
	# Card coloring and text
	match card.rarity:
		Card.Rarity.COMMON: type.modulate = Color(Color.GRAY)
		Card.Rarity.UNCOMMON: type.modulate = Color(Color.CORNFLOWER_BLUE)
		Card.Rarity.RARE: type.modulate = Color(Color.GOLD)
		Card.Rarity.STATUS: type.modulate = Color(Color.DARK_RED)
		Card.Rarity.PURPLE: type.modulate = Color(Color.PURPLE)
	_name.modulate = type.modulate
	cost.text = str(card.cost)
	desc.text = "[center]%s[/center]" % card.get_tooltip_text(null, null)
	_name.text = card.name
	type.text = " -%s" % (str(Card.Type.find_key(card.type))).capitalize()
	
	# Card name (Prevents names from going out of the cardui's area/hitbox)
	if _name.get_line_count() > 1 && !name_initialised:
		name_initialised = true
		cost.position.y = cost.position.y + (_name.get_line_count() * _name.get_line_height()) -10
		type.position.y = cost.position.y
		desc.position.y = desc.position.y + (_name.get_line_count() * _name.get_line_height()) -10
	
	# Card statuses
	for status in card.statuses:
		card.add_status(status)
	for child in card_statuses.get_children():
		child.queue_free()
		
	for status in card.statuses:
		var texture_rect := TextureRect.new()
		texture_rect.texture = status.icon
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture_rect.custom_minimum_size.y = 10
		card_statuses.add_child(texture_rect)


# It doesn't matter if cache cost can't hide as card menu uis are instanced whenever a card pile is opened
func show_cache_cost() -> void:
	card.set_cache_cost(0)
	cache_cost.text = "[right][color=D9BB26]%s[/color][/right]" % card.cache_cost
	cache_cost.show()


func _on_gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("middle_mouse"):
		OS.alert(card._to_string())


func _on_tooltip_mouse_entered() -> void:
	panel.set("theme_override_styles/panel", HOVER_STYLEBOX)
	card_tooltip.show_tooltip(card)


func _on_tooltip_mouse_exited() -> void:
	panel.set("theme_override_styles/panel",STYLEBOX)
	card_tooltip.modulate.a = 0
