class_name Tooltip extends PanelContainer

@export var fade_seconds := 0.2

@onready var tooltip_text_label: RichTextLabel = %TooltipText
@onready var hide_timer: Timer = %HideTimer

# Has to always be in scope
var tween: Tween
var is_showing := false
var is_playable := true


func _ready() -> void:
	Events.show_tooltip.connect(show_tooltop)
	Events.hide_tooltip.connect(hide_tooltip)
	Events.card_aim_ended.connect(enable_tooltip)
	Events.card_aim_started.connect(disable_tooltip)
	Events.card_drag_started.connect(disable_tooltip)
	Events.card_drag_ended.connect(enable_tooltip)
	modulate = Color.TRANSPARENT
	hide()


func _process(_delta: float) -> void:
	if !is_playable:
		hide_tooltip()


func show_tooltop(text: String) -> void:
	if name == "SettingsTooltip" && !get_parent().get_child(0).visible: return
	is_showing = true
	if tween: tween.kill()
	
	tooltip_text_label.text = "[center]%s[/center]" % text
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", Color.WHITE, fade_seconds)


# Starts a the timer before hiding
func hide_tooltip() -> void:
	is_showing = false
	if tween: tween.kill()
	if !is_inside_tree(): return
	
	hide_timer.start(fade_seconds)
	if !hide_timer.timeout.is_connected(hide_animation):
		hide_timer.timeout.connect(hide_animation)


func hide_animation() -> void:
	if !is_showing:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
		tween.tween_callback(hide)


func enable_tooltip(_card : CardUI) -> void:
	is_playable = true


func disable_tooltip(_card : CardUI) -> void:
	is_playable = false
