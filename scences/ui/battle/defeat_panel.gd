extends Panel

@onready var label: Label = %Label
@onready var restart_button: Button = %RestartButton
@onready var color_rect: ColorRect = %ColorRect


func _ready() -> void:
	restart_button.pressed.connect(get_tree().reload_current_scene)
	Events.update_battle_state.connect(show_screen)


func show_screen(state : Battle.BattleState) -> void:
		if state == Battle.BattleState.LOSE:
			restart_button.visible = true
			label.text = generate_text()
			await get_tree().create_timer(1).timeout
			color_rect.visible = true


func _process(_delta: float) -> void:
	if !color_rect.visible or color_rect.color.a > 0.8: return
	show()
	color_rect.color.a += 0.003


func generate_text() -> String:
	match randi_range(0, 2):
		0: label.label_settings.font_size = 16; return "Defeat"
		1: return "You died lol"
		2: return "Maybe try not\ndoing that next time?"
	return "Should've taken\nthat barrier card..."
