class_name ManaUI
extends Panel

@export var char_stats : CharacterStats : set = _set_char_stats

@onready var mana_label : Label = $ManaLabel


func _set_char_stats(value : CharacterStats) -> void:
	char_stats = value
	
	if !char_stats.stats_changed.is_connected(_on_stats_changed):
		char_stats.stats_changed.connect(_on_stats_changed)
	
	if !is_node_ready():
		await ready
	
	_on_stats_changed()


func _on_stats_changed() -> void:
	mana_label.text = "%s/%s" % [char_stats.mana, char_stats.max_mana]


func _on_mouse_entered() -> void:
	Events.card_tooltip_requested.emit("[center]Your [color=ffff00]memory[/color]
[color=ffff00]" + char_stats.mana_type + "[/color] decreases whenever you play cards and when looped card or summons are active[/center]")


func _on_mouse_exited() -> void:
	Events.tooltip_hide_requested.emit()
