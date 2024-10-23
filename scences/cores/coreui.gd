class_name CoreUI
extends Control

const PIPE = preload("res://assets/sfx/pipe.mp3")

@export var core: Core : set = set_core

@onready var icon: TextureRect = %Icon
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func set_core(value: Core) -> void:
	if !is_node_ready(): await ready
	core = value
	icon.texture = core.icon


func flash() -> void:
	animation_player.play("Flash")
	if core.core_name == "Comically Large Anvil":
		SFXPlayer.play(PIPE)


func show_tooltip() -> void:
	Events.show_tooltip.emit(
		"%s\n%s\n[i]%s[/i]" % [core.slotted_tooltip, core.dump_tooltip, core.flavour_text])


func hide_tooltip() -> void:
	Events.hide_tooltip.emit()
