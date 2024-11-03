class_name MemoryUI extends Panel

@onready var mana_label : Label = $ManaLabel


func _ready() -> void:
	if !Data.character.stats_changed.is_connected(_on_stats_changed):
		Data.character.stats_changed.connect(_on_stats_changed)
	
	_on_stats_changed()


func _on_stats_changed() -> void:
	mana_label.text = "%s/%s" % [Data.character.memory, Data.character.max_memory]


func _on_mouse_entered() -> void:
	Events.show_tooltip.emit("[center]Your [color=ffff00]memory[/color], decreases whenever you play cards and when looped card or summons are active[/center]")


func _on_mouse_exited() -> void:
	Events.hide_tooltip.emit()
