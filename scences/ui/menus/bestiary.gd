class_name Bestiary extends Control

@onready var core_view: Control = %CoreView
@onready var core_title: RichTextLabel = %CoreTitle
@onready var core_icon: TextureRect = %CoreIcon
@onready var core_text: RichTextLabel = %CoreText
@onready var color_rect: ColorRect = %ColorRect


func _ready() -> void:
	visibility_changed.connect(func()->void:
		color_rect.visible = visible)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		update_visibility(false)


func update_visibility(open: bool) -> void:
	visible = open
	# Deferred is to prevent settings from opening the smae frame this closes
	Data.set_deferred("bestiary_open", open)


func show_core(core: Core) -> void:
	if !visible: update_visibility(true)
	core_view.visible = true
	core_title.text = "[center]%s[/center]" % core.core_name
	core_icon.texture = core.icon
	core_text.text = "[center]%s\n\n%s\n\n%s[/center]" % [core.slotted_tooltip, core.dump_tooltip, core.flavour_text]


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse"):
		update_visibility(false)
