extends Control

const MAIN := preload("res://scences/main/main.tscn")
const MACHINE_STATS := preload("res://characters/machine/machine.tres")

@export var run_startup: RunStartup

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var character_portrait: TextureRect = %CharacterPortrait
@onready var scence_transition: AnimationPlayer = %ScenceTransition

var current_character: CharacterStats = MACHINE_STATS : set = set_current_character
var run_loading_started: bool

func _ready() -> void:
	scence_transition.play("fade_in")
	set_current_character(MACHINE_STATS)


func set_current_character(new_character: CharacterStats) -> void:
	current_character = new_character
	title.text = "Maybs remove this?"
	description.text = "And replace with starter summons which act kinda like Cobalt"
	character_portrait.texture = current_character.art


func _on_start_button_pressed() -> void:
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.picked_character = current_character
	run_loading_started = true
	scence_transition.play("fade_out")
	print("\nStarted a new run")
	print("Difficulty: %s" % run_startup.difficulty)
	print("Seed: ")


func _on_machine_button_pressed() -> void:
	current_character = MACHINE_STATS


func _on_scence_transition_animation_finished(_anim_name: StringName) -> void:
	if run_loading_started: get_tree().change_scene_to_packed(MAIN)
