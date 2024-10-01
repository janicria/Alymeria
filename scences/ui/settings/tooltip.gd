class_name Tooltip
extends PanelContainer

@export var fade_seconds := 0.2

@onready var tooltip_text_label: RichTextLabel = %TooltipText
@onready var hide_timer: Timer = %HideTimer

var tween : Tween
var is_visible := false
var is_playable := true


func _ready() -> void:
	Events.card_tooltip_requested.connect(show_tooltop)
	Events.settings_tooltip_requested.connect(show_settings)
	Events.tooltip_hide_requested.connect(hide_tooltip)
	Events.card_aim_ended.connect(enable_tooltip)
	Events.card_aim_started.connect(disable_tooltip)
	Events.card_drag_started.connect(disable_tooltip)
	Events.card_drag_ended.connect(enable_tooltip)
	modulate = Color.TRANSPARENT
	hide()


func _process(_delta: float) -> void:
	if !is_playable:
		hide_tooltip()


func show_settings(text : String) -> void:
	if !get_name() == "SettingsTooltip":
		return
	
	is_visible = true
	
	if tween:
		tween.kill()
	
	tooltip_text_label.text = text
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", Color.WHITE, fade_seconds)


func show_tooltop(text : String) -> void:
	if get_name() == "SettingsTooltip":
		return
	
	is_visible = true

	if tween:
		tween.kill()
	
	tooltip_text_label.text = text
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", Color.WHITE, fade_seconds)


# Starts a the timer to hide the tooltip
func hide_tooltip() -> void:
	is_visible = false
	
	if tween:
		tween.kill()
	
	hide_timer.start(fade_seconds)
	if !hide_timer.timeout.is_connected(hide_animation):
		hide_timer.timeout.connect(hide_animation)


func hide_animation() -> void:
	if !is_visible:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
		tween.tween_callback(hide)


func enable_tooltip(_card : CardUI) -> void:
	is_playable = true


func disable_tooltip(_card : CardUI) -> void:
	is_playable = false
