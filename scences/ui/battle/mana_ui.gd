class_name ManaUI
extends Panel


@onready var mana_label : Label = $ManaLabel


func _ready() -> void:
	if !GameManager.character.stats_changed.is_connected(_on_stats_changed):
		GameManager.character.stats_changed.connect(_on_stats_changed)
	
	_on_stats_changed()


func _on_stats_changed() -> void:
	mana_label.text = "%s/%s" % [GameManager.character.mana, GameManager.character.max_mana]


func _on_mouse_entered() -> void:
	Events.card_tooltip_requested.emit("[center]Your [color=ffff00]memory[/color]
[color=ffff00]" + GameManager.character.mana_type + "[/color] decreases whenever you play cards and when looped card or summons are active[/center]")


func _on_mouse_exited() -> void:
	Events.tooltip_hide_requested.emit()
