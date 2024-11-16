extends Status


func initalise_target(target: Node) -> void:
	# Getting / creating mod value
	var damage_taken_modifier: Modifier = target.modifier_handler.get_modifier_of_type(Modifier.Type.DMG_TAKEN)
	var webbed_value: ModifierValue = damage_taken_modifier.get_value("webbed")
	if !webbed_value:
		webbed_value = ModifierValue.create_modifier("webbed", ModifierValue.Type.PERCENT)
		webbed_value.percent_value =  1.3
		damage_taken_modifier.add_new_value(webbed_value)
	
	# Updating mod
	if !status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(damage_taken_modifier))


func _on_status_changed(damage_taken_modifier: Modifier) -> void:
	if duration <= 0 && damage_taken_modifier:
		damage_taken_modifier.remove_value("webbed")
