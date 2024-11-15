extends Node


func _ready() -> void:
	await get_parent().ready
	Data.bestiary = get_parent()
	get_parent().visibility_changed.connect(update_visibility)
	update_visibility()


func update_visibility() -> void:
	# Deferred is to prevent settings from opening when bestiary is closed
	Data.set_deferred("bestiary_open", get_parent().visible)
