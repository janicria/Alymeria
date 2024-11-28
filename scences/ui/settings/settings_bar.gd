extends TextureRect


const DEFAULT_BUS_LAYOUT = preload("res://assets/misc/default_bus_layout.tres")

@export var sfx_slider_sound : AudioStream

# TopVbox
@onready var gold_ui: GoldUI = %GoldUI
@onready var counter: RichTextLabel = %Counter
@onready var cog: TextureRect = %Cog
@onready var health_ui: HealthUI = %HealthUIMenu
# Misc
@onready var color_rect: ColorRect = %ColorRect
@onready var settings: Panel = %Settings
@onready var deck_button: CardPileButton = %DeckButton
@onready var deck_view: CardPileView = %DeckView
# Settings buttons / sliders
@onready var true_draw_button: Button = %TrueDrawButton
@onready var true_deck_button: Button = %TrueDeckButton
@onready var hints_button: Button = %HintsButton
@onready var speedy_cards_button: Button = %SpeedyCardsButton
@onready var master_volume: HSlider = %MasterVolumeSlider
@onready var sfx_volume: HSlider = %SFXVolumeSlider
@onready var music_volume: HSlider = %MusicVolumeSlider
@onready var fullscreen_button: Button = %FullscreenButton
@onready var pipe_button: Button = %PipeButton

var cog_speed_boost := 0.0


func _ready() -> void:
	Events.update_card_pile.connect(_setup)
	
	cog.pivot_offset = cog.size / 2
	_on_volume_slider_value_changed(0, "master")
	health_ui.update_stats(12, 99)
	
	if get_parent().get_name() == "MainMenu":
		deck_view.queue_free()
		deck_button.queue_free()
		counter.queue_free()
		gold_ui.queue_free()
		health_ui.queue_free()
		master_volume.editable = false
		sfx_volume.editable = false
		music_volume.editable = false


func _process(_delta: float) -> void:
	if cog_speed_boost < 0.01: return
	cog.rotation_degrees += cog_speed_boost * 1.5
	cog_speed_boost -= 0.02


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") && !Data.card_pile_open && !Data.bestiary_open: 
		toggle_settings()


func _setup(card_pile: CardPile) -> void:
	deck_button.card_pile = card_pile
	deck_view.card_pile = card_pile
	Data.character.deck = card_pile
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))
	Data.character.stats_changed.connect(func()->void:
		health_ui.update_stats(Data.character.health, Data.character.max_health))
	Data.character.stats_changed.emit()

	# Updates buttons changed in MainMenu
	_on_toggled_button_toggled(Data.true_draw_amount, "true_draw")
	_on_toggled_button_toggled(Data.true_deck_size, "true_deck")
	_on_toggled_button_toggled(Data.gameplay_tips, "hints")
	if DisplayServer.window_get_mode() == 3: _on_toggled_button_toggled(true, "fullscreen")
	_on_toggled_button_toggled(Data.speedy_cards, "speedy_cards")


func toggle_settings() -> void:
	settings.visible = !settings.visible
	if settings.visible :
		color_rect.visible = true
		get_tree().paused = true
	else:
		color_rect.visible = false
		get_tree().paused = false
		Events.hide_tooltip.emit()
		Events.update_deck_button_ui.emit()


func update_slider_volume(slider: String) -> void:
	match slider:
		"sfx":
			for child: AudioStreamPlayer in SFXPlayer.get_children():
				# If SFX is too loud the audio breaks
				child.volume_db = (sfx_volume.value / 4) * (master_volume.value / 100)
				if !sfx_volume.value or !master_volume.value: child.volume_db = -INF
		"music":
			for child: AudioStreamPlayer in MusicPlayer.get_children():
				child.volume_db = (music_volume.value / 2) * (master_volume.value / 100)
				if !music_volume.value or !master_volume.value: child.volume_db = -INF


func hide_tooltip() -> void:
	Events.hide_tooltip.emit()


func _on_cog_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse"):
		toggle_settings()
	
	cog.rotation_degrees += 5 + cog_speed_boost
	cog_speed_boost += 0.05


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse"): 
		toggle_settings()


# DO NOT MOVE <- but actually, don't move it as it disconnects the signals
func _on_toggled_button_toggled(toggled_on: bool, button_string: String) -> void:
	var button: Button
	match button_string:
		"true_draw": 
			button = %TrueDrawButton
			Data.true_draw_amount = toggled_on
			Events.update_draw_card_ui.emit()
		"true_deck": 
			button = %TrueDeckButton
			Data.true_deck_size = toggled_on
			Events.update_deck_button_ui.emit()
		"hints": 
			button = %HintsButton
			Data.gameplay_tips = toggled_on
		"fullscreen":
			button = %FullscreenButton
			if toggled_on: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_size(Vector2(1280, 720))
		"speedy_cards":
			button = %SpeedyCardsButton
			Data.speedy_cards = toggled_on
		"pipe":
			button = %PipeButton
			SFXPlayer.pipe = toggled_on
			if toggled_on: SFXPlayer.play(AudioStream.new())
	button.text = "Enabled" if toggled_on else "Disabled"


# DO NOT MOVE
func _on_volume_slider_value_changed(_value: float, slider: String) -> void: 
	if slider == "master":
		update_slider_volume("sfx")
		update_slider_volume("music")
	else: update_slider_volume(slider)


func _on_sfx_volume_drag_ended(_value_changed: bool) -> void:
	SFXPlayer.play(sfx_slider_sound)


# DO NOT MOVE
func _on_hbox_mouse_entered(text: String) -> void:
	Events.show_tooltip.emit("[center]%s[/center]" % text)


func _on_exit_button_pressed() -> void:
	print("Save & exit selected")
	if Data.save_to_file():
		print("Quitting...\nBelow is not actually a memory leak (trust)")
		get_tree().quit()


func _on_console_button_pressed() -> void:
	Events.toggle_console_visible.emit()
