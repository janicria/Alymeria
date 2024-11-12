class_name CoreUI extends Control

const PIPE = preload("res://assets/sfx/pipe.mp3")
const CURSOR = preload("res://assets/misc/cursor.png")
const BUBBLE_CURSOR = preload("res://assets/misc/bubble_cursor.png")

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


func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(CURSOR)


func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(BUBBLE_CURSOR)


func _on_gui_input(event: InputEvent) -> void:
	if playable && event.is_action_released("right_mouse") && core.type == Core.Type.RIGHT_CLICK && get_tree():
		core.activate()
		playable = false
		flash()
	elif event.is_action_released("left_mouse"):
		Data.bestiary.show_core(core)
		if core.core_name == "Comically Large Anvil":
			flash()
