extends Control

const DIFFICULTY_SCREEN := preload("res://scences/ui/menus/difficulty_screen.tscn")
const MACHINE_STATS := preload("res://characters/machine/machine.tres")
const WITCH_STATS := preload("res://characters/witch/witch.tres")

@export var run_startup: RunStartup

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var character_portrait: TextureRect = %CharacterPortrait
@onready var scence_transition: AnimationPlayer = %ScenceTransition

var current_character: CharacterStats : set = set_current_character
var difficulty_loading_started := false

func _ready() -> void:
	scence_transition.play("fade_in")
	set_current_character(MACHINE_STATS)


func set_current_character(new_character: CharacterStats) -> void:
	current_character = new_character
	title.text = current_character.character_name
	description.text = current_character.description
	character_portrait.texture = current_character.portrait


func _on_start_button_pressed() -> void:
	if current_character == WITCH_STATS:
		OS.alert("This character isn't available in the current version of the game", "Oopsie daisy")
		return
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.picked_character = current_character
	difficulty_loading_started = true
	scence_transition.play("fade_out")


func _on_machine_button_pressed() -> void:
	current_character = MACHINE_STATS


func _on_witch_button_pressed() -> void:
	current_character = WITCH_STATS


func _on_scence_transition_animation_finished(_anim_name: StringName) -> void:
	if difficulty_loading_started:
		get_tree().change_scene_to_packed(DIFFICULTY_SCREEN)
