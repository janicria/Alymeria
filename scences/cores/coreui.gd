class_name CoreUI extends Control

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


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("right_mouse") && core.type == Core.Type.RIGHT_CLICK:
		core.activate()
		flash()
	elif event.is_action_released("left_mouse") && core.core_name == "Comically Large Anvil":
		flash()
