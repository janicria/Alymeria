extends Panel

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continue_button: Button = %ContinueButton
@onready var restart_button: Button = %RestartButton

var text : String

func _ready() -> void:
	continue_button.pressed.connect(func()->void: Events.battle_won.emit())
	restart_button.pressed.connect(get_tree().reload_current_scene)
	Events.battle_state_updated.connect(show_screen)


func show_screen(state : Battle.BattleState) -> void:
	if state == 5:
		continue_button.visible = true
		restart_button.visible = false
		label.text = generate_win_text()
	elif state == 6:
		restart_button.visible = true
		continue_button.visible = false
		label.text = generate_lose_text()
	
	if state > 4:
		show()
		get_tree().paused = true


func generate_win_text() -> String:
	var rand_text := randi_range(1, 4)
	
	if rand_text == 1:
		label.label_settings.font_size = 16
		return "Victorirus"
	if rand_text == 2:
		label.label_settings.font_size = 16
		return "You win!"
	if rand_text == 3:
		label.label_settings.font_size = 14
		return "Too easy"
	if rand_text == 4:
		label.label_settings.font_size = 10
		return "Not even a stratch"

	return "Congrats! 
You broke the victory message script! 
(Please tell Janicria about this)"

func generate_lose_text() -> String:
	var rand_text := randi_range(1, 4)
	
	if rand_text == 1:
		label.label_settings.font_size = 16
		return "Defeat"
	if rand_text == 2:
		return "You died lol"
	if rand_text == 3:
		return "Maybe try not 
doing that next time?"
	if rand_text == 4:
		return "Should've taken 
that barrier card..."

	return "Congrats! 
You broke the lose message script! 
(Please tell Janicria about this)"
