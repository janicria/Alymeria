extends TextureRect

const DEFAULT_BUS_LAYOUT = preload("res://assets/default_bus_layout.tres")

@export var sfx_slider_sound : AudioStream

@onready var gold_ui: GoldUI = %GoldUI
@onready var counter: Label = %Counter
@onready var cog: TextureRect = %Cog
@onready var color_rect: ColorRect = %ColorRect
@onready var settings: Panel = %Settings
@onready var true_draw_button: Button = %TrueDrawButton
@onready var true_deck_button: Button = %TrueDeckButton
@onready var hints_button: Button = %HintsButton
@onready var sfx_volume: HSlider = %SFXVolume
@onready var music_volume: HSlider = %MusicVolume
@onready var master_volume: HSlider = %MasterVolume
@onready var fullscreen_button: Button = %FullscreenButton
@onready var pile_button: Button = %PileButton
@onready var deck_button: CardPileButton = %DeckButton
@onready var deck_view: CardPileView = %DeckView

var cog_speed_boost := 0.0
var mouse_on_cog := false


func  _ready() -> void:
	Events.update_card_pile.connect(_setup)
	
	cog.pivot_offset = Vector2(7.5, 10)
	
	if get_parent().get_name() == "MainMenu":
		texture = null
		deck_view.queue_free()
		deck_button.queue_free()
		counter.queue_free()
		gold_ui.queue_free()
	settings.visible = false
	color_rect.visible = false


func _setup(card_pile : CardPile) -> void:
	deck_button.card_pile = card_pile
	deck_view.card_pile = card_pile
	GameSave.character.deck = card_pile
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))


func _on_cog_gui_input(event: InputEvent) -> void:
	mouse_on_cog = true
	if event.is_action_released("left_mouse_pressed"):
		settings_open_state(true)


func _process(_delta: float) -> void:
	if mouse_on_cog:
		cog.rotation_degrees += 6 + cog_speed_boost
		cog_speed_boost += 0.01
	elif cog_speed_boost > 0:
		cog.rotation_degrees += cog_speed_boost * 1.5
		cog_speed_boost -= 0.04
	mouse_on_cog = false
	
	if !color_rect.visible:
		return
	
	color_rect.visible = deck_view.visible


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse_pressed"):
		if get_global_mouse_position().x < 42 or get_global_mouse_position().x > 292:
			settings_open_state(false)
		if get_global_mouse_position().y < 19 or get_global_mouse_position().y > 169:
			settings_open_state(false)


func settings_open_state(open : bool) -> void:
	if open:
		settings.visible = true
		color_rect.visible = true
		get_tree().paused = true
	else:
		settings.visible = false
		color_rect.visible = false
		get_tree().paused = false
		Events.update_deck_counter.emit()


func _on_hints_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		hints_button.text = "Enabled"
	else:
		hints_button.text = "Disabled"
	GameSave.gameplay_tips = toggled_on


func _on_true_draw_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		true_draw_button.text = "Enabled"
	else:
		true_draw_button.text = "Disabled"
	GameSave.true_draw_amount = toggled_on
	Events.update_deck_buttons.emit(0, false)


func _on_sfx_volume_value_changed(value: float) -> void:
	for child: AudioStreamPlayer in SFXPlayer.get_children():
		child.volume_db = (sfx_volume.value - 32) * (master_volume.value / 100)
		if !sfx_volume.value:
			child.volume_db = -INF


func _on_music_volume_value_changed(value: float) -> void:
	for child: AudioStreamPlayer in MusicPlayer.get_children():
		child.volume_db = (music_volume.value - 32) * (master_volume.value / 100)
		if !music_volume.value:
			child.volume_db = -INF


func _on_sfx_volume_drag_ended(_value_changed: bool) -> void:
	SFXPlayer.play(sfx_slider_sound)


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen_button.text = "Enabled"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2(1280, 720))
		fullscreen_button.text = "Disabled"


func _on_pile_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		pile_button.text = "Inside"
	else:
		pile_button.text = "Outside"
	GameSave.card_pile_above_mana = toggled_on
	Events.update_deck_buttons.emit(0, false)


func _on_true_deck_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		true_deck_button.text = "Enabled"
	else:
		true_deck_button.text = "Disabled"
	GameSave.true_deck_size = toggled_on
	Events.update_deck_buttons.emit(0, false)


func _on_h_box_container_2_mouse_entered() -> void:
	Events.settings_tooltip_requested.emit("[center]Show useful gameplay hints during menus
(recommended)[/center]")


func _on_h_box_container_mouse_entered() -> void:
	Events.settings_tooltip_requested.emit("[center]Cards which draw show how far they move your deck[/center]")

func _on_h_box_container_4_mouse_entered() -> void:
	Events.settings_tooltip_requested.emit("[center]Deck counter doesn't show cards which exhaust[/center]")


func _on_h_box_container_3_mouse_entered() -> void:
	Events.settings_tooltip_requested.emit("[center]Moves your draw and discard pile buttons to a more accessible place[/center]")


func hide_settings_tooltip() -> void:
	Events.tooltip_hide_requested.emit()
