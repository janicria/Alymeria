extends TextureRect


const DEFAULT_BUS_LAYOUT = preload("res://assets/misc/default_bus_layout.tres")

@export var sfx_slider_sound : AudioStream

# TopVbox
@onready var gold_ui: GoldUI = %GoldUI
@onready var counter: RichTextLabel = %Counter
@onready var cog: TextureRect = %Cog
@onready var health_ui: HealthUI = %HealthUI
# Misc
@onready var color_rect: ColorRect = %ColorRect
@onready var settings: Panel = %Settings
@onready var deck_button: CardPileButton = %DeckButton
@onready var deck_view: CardPileView = %DeckView
# Settings buttons / sliders
@onready var true_draw_button: Button = %TrueDrawButton
@onready var true_deck_button: Button = %TrueDeckButton
@onready var hints_button: Button = %HintsButton
@onready var sfx_volume: HSlider = %SFXVolumeSlider
@onready var music_volume: HSlider = %MusicVolumeSlider
@onready var master_volume: HSlider = %MasterVolumeSlider
@onready var fullscreen_button: Button = %FullscreenButton
@onready var pile_button: Button = %CardPilePosButton


var cog_speed_boost := 0.0


func _ready() -> void:
	Events.update_card_pile.connect(_setup)
	
	cog.pivot_offset = cog.size / 2
	_on_volume_slider_value_changed(0, "master")
	
	if get_parent().get_name() == "MainMenu":
		deck_view.queue_free()
		deck_button.queue_free()
		counter.queue_free()
		gold_ui.queue_free()
		health_ui.queue_free()


func _setup(card_pile : CardPile) -> void:
	deck_button.card_pile = card_pile
	deck_view.card_pile = card_pile
	GameManager.character.deck = card_pile
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))
	GameManager.character.stats_changed.connect(health_ui.update_stats.bind(GameManager.character))
	health_ui.update_stats(GameManager.character)
	
	# Updates buttons from MainMenu / restarting run
	_on_toggled_button_toggled(GameManager.true_draw_amount, "true_draw")
	_on_toggled_button_toggled(GameManager.true_deck_size, "true_deck")
	_on_toggled_button_toggled(GameManager.gameplay_tips, "hints")
	if DisplayServer.window_get_mode() == 3: _on_toggled_button_toggled(true, "fullscreen")
	_on_toggled_button_toggled(GameManager.card_pile_above_mana, "card_pile_pos")


func _on_cog_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse_pressed"):
		toggle_settings()
	
	cog.rotation_degrees += 5 + cog_speed_boost
	cog_speed_boost += 0.05


func _process(_delta: float) -> void:
	# Prevents camera from moving screen position
	global_position.y = 0 - get_canvas_transform().origin.y
	
	if cog_speed_boost < 0.01: return
	cog.rotation_degrees += cog_speed_boost * 1.5
	cog_speed_boost -= 0.02


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse_pressed"): toggle_settings()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") && !GameManager.card_pile_open: toggle_settings()


func toggle_settings() -> void:
	settings.visible = !settings.visible
	if settings.visible :
		color_rect.visible = true
		get_tree().paused = true
	else:
		color_rect.visible = false
		get_tree().paused = false
		Events.tooltip_hide_requested.emit()
		Events.update_deck_counter.emit()


func _on_toggled_button_toggled(toggled_on: bool, button_string: String) -> void:
	var button: Node
	match button_string:
		"true_draw": 
			button = %TrueDrawButton
			GameManager.true_draw_amount = toggled_on
			Events.update_card_stats.emit()
		"true_deck": 
			button = %TrueDeckButton
			GameManager.true_deck_size = toggled_on
			Events.update_deck_buttons.emit(0, false)
		"hints": 
			button = %HintsButton
			GameManager.gameplay_tips = toggled_on
		"fullscreen":
			button = %FullscreenButton
			if toggled_on: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_size(Vector2(1280, 720))
		"card_pile_pos": 
			button = %CardPilePosButton
			if toggled_on: pile_button.text = "Inside"
			else: pile_button.text = "Outside"
			GameManager.card_pile_above_mana = toggled_on
			Events.update_deck_buttons.emit(0, false)
	
	# We don't want to override the inside/outside text
	if button == %CardPilePosButton: return
	
	if toggled_on: button.text = "Enabled"
	else: button.text = "Disabled"


func _on_volume_slider_value_changed(_value: float, slider: String) -> void: 
	if slider == "master":
		update_slider_volume("sfx")
		update_slider_volume("music")
	else: update_slider_volume(slider)


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


func _on_sfx_volume_drag_ended(_value_changed: bool) -> void:
	SFXPlayer.play(sfx_slider_sound)


func _on_hbox_mouse_entered(text: String) -> void:
	Events.settings_tooltip_requested.emit("[center]" + text + "[/center]")


func _on_exit_button_pressed() -> void:
	print("Save & exit selected")
	if GameManager.save_to_file():
		print("Quitting...\nBelow is not actually a memory leak (trust)")
		get_tree().quit()


func hide_tooltip() -> void:
	Events.tooltip_hide_requested.emit()


func _on_console_button_pressed() -> void:
	Events.toggle_console_visible.emit()
