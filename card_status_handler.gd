class_name CardStatusHandler
extends VBoxContainer

@export var statuses: Array[CardStatus]


func has_status(status: CardStatus) -> bool:
	return statuses.has(status)


func add_status(status: CardStatus) -> void:
	if !statuses.has(status):
		statuses.append(status)
		update_ui()


func remove_status(status: CardStatus) -> void:
	if statuses.has(status):
		statuses.erase(status)
		update_ui()


func update_ui() -> void:
	for child in get_children():
		child.queue_free()
	
	for status in statuses:
		var texture_rect := TextureRect.new()
		texture_rect.texture = status.icon
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture_rect.custom_minimum_size.x = 10
		texture_rect.mouse_entered.connect(func()->void: Events.card_tooltip_requested.emit(status.description))
		texture_rect.mouse_exited.connect(func()->void: Events.tooltip_hide_requested.emit())
		add_child(texture_rect)
		print(texture_rect.visible)
		print(texture_rect.visibility_layer)
