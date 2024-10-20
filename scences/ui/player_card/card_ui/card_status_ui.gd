class_name CardStatusUI
extends VBoxContainer

@export var cardui: CardUI


func update_ui() -> void:
	for child in get_children():
		child.queue_free()
	
	for status in cardui.card.statuses:
		var texture_rect := TextureRect.new()
		texture_rect.texture = status.icon
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture_rect.custom_minimum_size.y = 10
		texture_rect.mouse_entered.connect(func()->void: Events.show_tooltip.emit(status.description))
		texture_rect.mouse_exited.connect(func()->void: Events.hide_tooltip.emit())
		add_child(texture_rect)
