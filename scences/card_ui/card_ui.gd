class_name  CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)
signal transition_requested(from: CardState, to: CardState.State)

const BASE_STYLEBOX := preload("res://scences/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scences/card_ui/card_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scences/card_ui/card_hover_stylebox.tres")

@export var card: Card : set = set_card
@export var char_stats : CharacterStats : set = _set_char_stats

@onready var panel : Panel = $Panel
@onready var cost : Label = $Cost
@onready var type: Label = $Type
@onready var icon : TextureRect = $Icon
@onready var desc : Label = $Desc
@onready var _name: Label = $Name
@onready var drop_point_detector : Area2D = $DropPointDetector
@onready var card_state_machine : CardSateMachine = $CardStateMachine
@onready var targets: Array[Node] = []

# These seemingly random member vars cannot be removed as they're referenced in various other scripts
var original_index := 0
var parent : Control
var tween : Tween
var playable := true : set = _set_playable
var disabled := false


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
	if !card:
		return
	
	if targets:
		card.play(targets, char_stats)
		queue_free()


func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


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


func _set_playable(value : bool) -> void:
	playable = value
	if !playable:
		cost.add_theme_color_override("font_color", Color.RED)
		_name.modulate.a = 0.5
		type.modulate.a = 0.5
		desc.modulate.a = 0.5
		cost.modulate.a = 0.8
	else:
		cost.remove_theme_color_override("font_color")
		_name.modulate.a = 1
		type.modulate.a = 1
		desc.modulate.a = 1
		cost.modulate.a = 1


func _set_char_stats(value : CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)


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
	playable = char_stats.can_play_card(card)


func _on_char_stats_changed() -> void:
	playable = char_stats.can_play_card(card)
