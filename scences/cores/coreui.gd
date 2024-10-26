class_name CoreUI extends Control

const PIPE = preload("res://assets/sfx/pipe.mp3")

@export var core: Core : set = set_core

@onready var icon: TextureRect = %Icon
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var slotted: bool
var playable := false : set = set_playable


func set_core(value: Core) -> void:
	if !is_node_ready(): await ready
	core = value
	core.coreui = self
	icon.texture = core.icon


func set_playable(value: bool) -> void:
	playable = value
	if !playable: modulate = Color.WHITE.darkened(0.3)
	else: modulate = Color.WHITE


func flash() -> void:
	animation_player.play("Flash")
	if core.core_name == "Comically Large Anvil":
		SFXPlayer.play(PIPE)


func show_tooltip() -> void:
	Events.show_tooltip.emit(
		"%s\n%s\n[i]%s[/i]" % [core.slotted_tooltip, core.dump_tooltip, core.flavour_text])


func hide_tooltip() -> void:
	Events.hide_tooltip.emit()


func _on_gui_input(event: InputEvent) -> void:
	if playable && event.is_action_released("right_mouse") && core.type == Core.Type.RIGHT_CLICK && get_tree():
		core.activate()
		playable = false
		flash()
	elif event.is_action_released("left_mouse") && core.core_name == "Comically Large Anvil":
		flash()
