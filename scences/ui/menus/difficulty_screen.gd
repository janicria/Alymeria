extends Control

const MAIN := preload("res://scences/main/main.tscn")

@export var run_startup: RunStartup

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var character_portrait: TextureRect = %CharacterPortrait
@onready var scence_transition: AnimationPlayer = %ScenceTransition
@onready var left_description: Label = %LeftDescription
@onready var right_description: Label = %RightDescription

var run_loading_started := false

func _ready() -> void:
	if !run_startup.picked_character:
		return
	
	scence_transition.play("fade_in")
	character_portrait.texture = run_startup.picked_character.portrait


func _on_standard_button_pressed() -> void:
	left_description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	left_description.position = Vector2(12, 50)
	right_description.position = Vector2(12, 50)
	description.text = "Just your standard difficulty where you try to survive in Alymeria"
	left_description.text = ""
	right_description.text = ""
	run_startup.difficulty = RunStartup.Difficulity.STANDARD


func _on_threatening_button_pressed() -> void:
	left_description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	left_description.position = Vector2(12, 50)
	right_description.position = Vector2(12, 50)
	description.text = " Start each run with 5 less health
Enemies deal 5% more damage
Shops cost 5% more
Enemies are infected 20% more often"
	left_description.text = ""
	right_description.text = ""
	run_startup.difficulty = RunStartup.Difficulity.THREATENING


func _on_hazardous_button_pressed() -> void:
	left_description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	left_description.position = Vector2(12, 50)
	right_description.position = Vector2(12, 50)
	description.text = ""
	left_description.text = "Start each run with 5 less health
Lose 5 max health
Enemies gain 10% more barrier
Enemies deal 20% more damage"
	right_description.text = "Enemies have 10% more health
Enemies have stronger abilities
Shops cost 15% more
Enemies are infected 25% more often"
	run_startup.difficulty = RunStartup.Difficulity.HAZARDOUS


func _on_lethal_button_pressed() -> void:
	left_description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	right_description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	left_description.position = Vector2(12, 50)
	right_description.position = Vector2(12, 50)
	description.text = ""
	left_description.text = "Start each run with 10 less health
Lose 5 max health
Enemies gain 10% more barrier
Enemies deal 30% more damage
Enemies have 15% more health"
	right_description.text = "Enemies have stronger abilities
Bosses have even stronger abilities
Shops cost 20% more
Enemies are infected 30% more often
You cannot heal more than 20 health in one go"
	run_startup.difficulty = RunStartup.Difficulity.LETHAL


func _on_death_button_pressed() -> void:
	description.text = ""
	left_description.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	right_description.position = Vector2(12, 45)
	left_description.position =  Vector2(12, 42)
	left_description.text = "Start each run with 15 less health
Lose 10 max health
Enemies gain 10% more barrier
Enemies deal 30% more damage
Enemies have 30% more health
Enemies have stronger abilities"
	right_description.text = "Bosses have even stronger abilities
A certain boss really hates you
Certain events are worse
You can no longer use free actions
Shops cost 20% more
Start each run with Deadly Spores
Enemies are infected 30% more often
You cannot heal more than 20 health in one go"
	run_startup.difficulty = RunStartup.Difficulity.DEATH

func _on_start_button_pressed() -> void:
	if run_startup.difficulty:
		print("\nStarted a new run")
		print("Character: %s " % run_startup.picked_character.character_name)
		print("Difficulty: %s" % run_startup.difficulty)
		print("Seed: ")
		scence_transition.play("fade_out")
		run_loading_started = true


func _on_scence_transition_animation_finished(_anim_name: StringName) -> void:
	if run_loading_started: get_tree().change_scene_to_packed(MAIN)
