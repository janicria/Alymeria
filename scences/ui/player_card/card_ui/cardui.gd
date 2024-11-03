class_name  CardUI extends Control

signal reparent_requested(card_ui: CardUI)
signal transition_requested(from: CardState, to: CardState.State)

const BASE_STYLEBOX := preload("res://scences/ui/player_card/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scences/ui/player_card/card_ui/card_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scences/ui/player_card/card_ui/card_hover_stylebox.tres")

@export var card: Card : set = set_card

@onready var panel : Panel = $Panel
@onready var cost : Label = $Cost
@onready var type: Label = $Type
@onready var icon : TextureRect = $Icon
@onready var desc : RichTextLabel = $Desc
@onready var _name: Label = $Name
@onready var drop_point_detector : Area2D = $DropPointDetector
@onready var card_state_machine : CardSateMachine = %CardStateMachine
@onready var card_statuses: VBoxContainer = $CardStatuses
@onready var targets: Array[Node] = []

# Members below are referenced in various other scripts
var player_modifiers: ModifierHandler
var stats := func()->String: 
	return "%s - %s\n\n%s - %s" % [card.name, card.unique_id, self, get_index()]
var original_index := 0
var parent: Control
var tween: Tween
var playable := true : set = set_playable
var disabled := false
var canceled := false
var name_initialised := false


func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aiming_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aiming_ended)
	Data.character.stats_changed.connect(_on_character_changed)
	card_state_machine.init(self)


func  _input(event : InputEvent) -> void:
	card_state_machine.on_input(event)


func set_card(value: Card) -> void:
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
	desc.text = "[center]%s[/center]" % card.get_tooltip_text(player_modifiers, null)
	_name.text = card.name
	type.text = " -%s" % (str(Card.Type.find_key(card.type))).capitalize()
	
	# Card name (Prevents names from going out of the cardui's area/hitbox)
	if _name.get_line_count() > 1 && !name_initialised:
		name_initialised = true
		cost.position.y = cost.position.y + (_name.get_line_count() * _name.get_line_height()) -5
		type.position.y = cost.position.y
		desc.position.y = desc.position.y + (_name.get_line_count() * _name.get_line_height()) -5
	
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
		if status.name == "lucky_draw": texture_rect.mouse_entered.connect(func()->void: 
			Events.show_tooltip.emit(status.description % card.chance))
		else: texture_rect.mouse_entered.connect(func()->void: Events.show_tooltip.emit(status.description))
		texture_rect.mouse_exited.connect(func()->void: Events.hide_tooltip.emit())
		card_statuses.add_child(texture_rect)
		if card.has_status("unplayable"): playable = false


func set_playable(value : bool) -> void:
	playable = value
	if !playable:
		cost.add_theme_color_override("font_color", Color.RED)
		_name.modulate.a = 0.5
		type.modulate.a = 0.5
		desc.modulate.a = 0.5
		cost.modulate.a = 0.8
	
	elif !canceled && !card.has_status("unplayable"):
		cost.remove_theme_color_override("font_color")
		_name.modulate.a = 1
		type.modulate.a = 1
		desc.modulate.a = 1
		cost.modulate.a = 1


func animate_to_position(new_position : Vector2, duration : float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)


func play() -> void:
	if card.has_status("unplayable"):
		card_state_machine._on_transition_requested(card_state_machine.current_state, CardState.State.BASE)
		return
	
	# Prevents playing single target cards for an enemy during its death animation
	if card.is_single_targeted() && targets.any(func(target: Node)-> bool: return target is Enemy):
		if targets.any(func(target: Enemy)-> bool: return !target.is_alive):
			card_state_machine._on_transition_requested(card_state_machine.current_state, CardState.State.BASE)
			return
	
	if card.has_status("burn") && Data.character.deck.has_card(card):
		Data.character.deck.remove_card(card)
	
	if targets:
		card.play(targets, player_modifiers)
		Data.character.cache_tokens += 1
		Events.update_deck_button_ui.emit()
		queue_free()


func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	if event.is_action_pressed("middle_mouse"): 
		OS.alert(stats.call(), "Card stats")


func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	z_index = 1


func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	z_index = 0


func _on_drop_point_detector_area_entered(area : Area2D) -> void:
	if !targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area : Area2D) -> void:
	targets.erase(area)


func _on_card_drag_or_aiming_started(used_card : CardUI) -> void:
	if used_card == self: return
	disabled = true


func _on_card_drag_or_aiming_ended(_card : CardUI) -> void:
	disabled = false
	playable = Data.character.can_play_card(card)


func _on_character_changed() -> void:
	# In case the player dies before the cardui has finished loading
	if !card: return
	playable = Data.character.can_play_card(card)
