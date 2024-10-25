extends Panel

@onready var label: Label = %Label
@onready var restart_button: Button = %RestartButton
@onready var color_rect: ColorRect = %ColorRect


func _ready() -> void:
	restart_button.pressed.connect(get_tree().reload_current_scene)
	Events.update_battle_state.connect(show_screen)


func _process(_delta: float) -> void:
	if !color_rect.visible or color_rect.color.a > 0.8: return
	color_rect.color.a += 0.003


func show_screen(state: Battle.State) -> void:
		if state == Battle.State.LOSE:
			restart_button.visible = true
			match randi_range(0, 3):
				0: label.label_settings.font_size = 16; label.text = "Defeat"
				1: label.text =  "You died lol"
				2: label.text =  "Maybe try not\ndoing that next time?"
				3: label.text = "Should've taken\nthat barrier card..."
			await get_tree().create_timer(1.0).timeout
			color_rect.visible = true
			show()
