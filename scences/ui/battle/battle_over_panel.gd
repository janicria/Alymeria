extends Panel


@onready var label: Label = %Label
@onready var continue_button: Button = %ContinueButton
@onready var restart_button: Button = %RestartButton
@onready var color_rect: ColorRect = %ColorRect


func _ready() -> void:
	restart_button.pressed.connect(get_tree().reload_current_scene)
	Events.update_battle_state.connect(show_screen)


func show_screen(state : Battle.BattleState) -> void:
	match state:
		5:
			continue_button.visible = true
			restart_button.visible = false
			label.text = generate_win_text()
		6:
			restart_button.visible = true
			continue_button.visible = false
			label.text = generate_lose_text()
			await get_tree().create_timer(1).timeout
			color_rect.visible = true


func _process(_delta: float) -> void:
	if !color_rect.visible or color_rect.color.a > 0.8: return
	show()
	color_rect.color.a += 0.003


func generate_win_text() -> String:
	match randi_range(0, 3):
		0:
			label.label_settings.font_size = 16
			return "Victorirus"
		1:
			label.label_settings.font_size = 16
			return "You win!"
		2:
			label.label_settings.font_size = 14
			return "Too easy"
		3:
			label.label_settings.font_size = 10
			return "Not even a stratch"
	
	GameManager.notify("Unable to return victory screen text")
	return ""

func generate_lose_text() -> String:
	match randi_range(0, 3):
		0: label.label_settings.font_size = 16; return "Defeat"
		1: return "You died lol"
		2: return "Maybe try not\ndoing that next time?"
		3: return "Should've taken\nthat barrier card..."
	
	GameManager.notify("Unable to return defeat screen text")
	return ""
