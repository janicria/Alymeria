extends Control


func item_clicked(input: InputEvent, item: String) -> void:
	if !input.is_action_pressed("left_mouse"): return
	get_node(item).modulate = Color.WHITE.darkened(0.3)
	get_node(item).get_child(-1).show()
	
	match item:
		"Service": Data.character.heal(ceili(Data.character.max_health * 0.4))


func _on_begone_button_pressed() -> void:
	Events.shop_exited.emit()
