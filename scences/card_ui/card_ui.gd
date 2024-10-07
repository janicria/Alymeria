class_name  CardUI
extends Control

signal reparent_requested(card_ui: CardUI)
signal transition_requested(from: CardState, to: CardState.State)

const BASE_STYLEBOX := preload("res://scences/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scences/card_ui/card_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scences/card_ui/card_hover_stylebox.tres")

@export var card: Card : set = set_card
@export var player_modifiers: ModifierHandler

@onready var panel : Panel = $Panel
@onready var cost : Label = $Cost
@onready var type: Label = $Type
@onready var icon : TextureRect = $Icon
@onready var desc : Label = $Desc
@onready var _name: Label = $Name
@onready var drop_point_detector : Area2D = $DropPointDetector
@onready var card_state_machine : CardSateMachine = %CardStateMachine
@onready var targets: Array[Node] = []

# These seemingly random member vars cannot be removed as they're referenced in various other scripts
var original_index := 0
var parent : Control
var tween : Tween
var playable := true : set = _set_playable
var disabled := false
var canceled := false
var ui_initialised := false


func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aiming_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aiming_ended)
	card_state_machine.init(self)


func  _input(event : InputEvent) -> void:
	card_state_machine.on_input(event)


func _on_gui_input(event : InputEvent) -> void:
	card_state_machine.on_gui_input(event)


func animate_to_position(new_position : Vector2, duration : float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)


func play() -> void:
	if !card: return
	
	# Prevents playing single target cards for an enemy during its death animation
	if card.is_single_targeted() && targets.any(func(target: Node)-> bool: return target is Enemy):
		if targets.any(func(target: Enemy)-> bool: return !target.is_alive):
			card_state_machine._on_transition_requested(card_state_machine.current_state, CardState.State.BASE)
			return
	
	if targets:
		card.play(targets, player_modifiers)
		GameManager.character.cache_tokens += 1
		Events.update_deck_buttons.emit(0, false)
		queue_free()


func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	z_index = 1


func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	z_index = 0

func set_card(value : Card) -> void:
	if ! is_node_ready(): await ready
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
		2: type.text = " -Looped" if GameManager.character.character_name == "Machine" else " -Summon"
		3: type.text = " -Status"
		4: type.text = " -Malware" if GameManager.character.character_name == "Machine" else " -Hex"
	
	# Prevents card names from going out of its area/hitbox
	if _name.get_line_count() > 1 && !ui_initialised:
		ui_initialised = true
		cost.position.y = cost.position.y + (_name.get_line_count() * _name.get_line_height()) -5
		type.position.y = cost.position.y
		desc.position.y = desc.position.y + (_name.get_line_count() * _name.get_line_height()) -5


func _set_playable(value : bool) -> void:
	playable = value
	if !playable:
		cost.add_theme_color_override("font_color", Color.RED)
		_name.modulate.a = 0.5
		type.modulate.a = 0.5
		desc.modulate.a = 0.5
		cost.modulate.a = 0.8
	elif canceled: return
	else:
		cost.remove_theme_color_override("font_color")
		_name.modulate.a = 1
		type.modulate.a = 1
		desc.modulate.a = 1
		cost.modulate.a = 1


func _on_drop_point_detector_area_entered(area : Area2D) -> void:
	if !targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area : Area2D) -> void:
	targets.erase(area)


func _on_card_drag_or_aiming_started(used_card : CardUI) -> void:
	if used_card == self:
		return
	
	disabled = true


func _on_card_drag_or_aiming_ended(_card : CardUI) -> void:
	disabled = false
	playable = GameManager.character.can_play_card(card)


func _on_GameManager_character_changed() -> void:
	playable = GameManager.character.can_play_card(card)
