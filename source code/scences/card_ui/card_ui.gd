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
	
	if has_targets():
		card.play(targets, char_stats)
		queue_free()
		


# Dependency for other scripts # <- TODO: Is it actually though?
func has_targets() -> bool:
	if targets:
		return true
	
	return false


func add_back_to_hand() -> bool:
	if card.is_summon_only:
		for Object in targets:
			if !Object is Summon:
				targets.erase(Object)
	
		if !targets:
			return false
	
	return true


func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func set_card(value : Card) -> void:
	if ! is_node_ready():
		await ready
	
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
		if char_stats.id == "Machine":
			type.text = "  -Looped"
		elif char_stats.id == "Machine":
			type.text = " -Summon"
	elif card.type == 3:
		type.text = " -Status"
	elif card.type == 4:
		if char_stats.id == "Machine":
			type.text = " -Malware"
		elif char_stats.id == "Machine":
			type.text = " -Hex"
	
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


func _on_card_drag_or_aiming_started(used_card : Card) -> void:
	if used_card == self:
		return
	
	disabled = true


func _on_card_drag_or_aiming_ended(_card : Card) -> void:
	disabled = false
	self.playable = char_stats.can_play_card(card)


func _on_char_stats_changed() -> void:
	self.playable = char_stats.can_play_card(card)
