extends Control

const MAIN := preload("res://scences/main/main.tscn")

@onready var scence_transition: AnimationPlayer = %ScenceTransition

var cog_speed_boost := 0.0
var mouse_on_cog := false
var texture : ImageTexture


func _ready() -> void:
	var image := get_viewport().get_texture().get_image()
	texture = ImageTexture.create_from_image(image)


func _on_continue_pressed() -> void:
	OS.alert("Yeah sure, with what save file?")


func _on_new_run_pressed() -> void:
	scence_transition.play("fade_out")


func _on_exit_pressed() -> void:
	print("Below is not actually a memory leak (trust)")
	get_tree().quit()


func _on_cog_gui_input(_event: InputEvent) -> void:
	mouse_on_cog = true


func _on_scence_transition_animation_finished(_anim_name: StringName) -> void:
		get_tree().change_scene_to_packed(MAIN)
